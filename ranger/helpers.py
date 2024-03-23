import os

from ranger.ext.get_executables import get_executables
from subprocess import Popen, PIPE

REQUIRED_BIN = {
    "ripgrep": "rg",
    "fzf": "fzf",
    "preview": "bat",
    "awk": "awk",
}


def check_required_bin():
    for bin in REQUIRED_BIN.values():
        if bin not in get_executables():
            raise Exception(f"Couldn't find {bin} in the PATH")


def run_cmd(
    cmd: list | str,
    *,
    stdin: int | None = PIPE,
    stdout: int | None = PIPE,
    universal_newlines=True,
    text=True,
    **kwargs,
) -> Popen:
    proc = Popen(
        cmd,
        stdin=stdin,
        stdout=stdout,
        text=text,
        universal_newlines=universal_newlines,
        **kwargs,
    )
    return proc


def to_str(input: str | list) -> str:
    if isinstance(input, list):
        return " ".join(input)
    return input


def rc_list(cmd: str | list) -> list:
    errors = [0]
    if "fzf" in cmd:
        errors.append(130)  # ESC => 130
    if "rg" in cmd:
        errors.append(1)  # NotFound => 1
    return errors


def wrap_cmd(cmd: list | str, fm, **kwargs):
    fm.ui.suspend()
    allowed_rc = rc_list(cmd)
    try:
        try:
            input = kwargs.pop("input")
        except KeyError:
            input = None

        proc = run_cmd(cmd, **kwargs)
        stdout, stderr = proc.communicate(input=input)

        if proc.returncode not in allowed_rc:
            msg = f"RC: {proc.returncode}, cmd: {to_str(cmd)!r}"
            if stdout:
                msg += f", stdout={stdout}"
            if stderr:
                msg += f", stderr={stderr}"
            raise Exception(msg)
    finally:
        fm.ui.initialize()
    return stdout.strip()


def show_error(fm, msg):
    fm.notify(msg, bad=True)


def navigate_path(fm, selected):
    if not selected:
        return

    selected = os.path.abspath(selected)
    if os.path.isdir(selected):
        fm.cd(selected)
    elif os.path.isfile(selected):
        dir = os.path.dirname(selected)
        fm.cd(dir)
        fm.select_file(selected)
    else:
        show_error(fm, f"Neither directory nor file: {selected}")
        return


def find(fm, type: str, name: str | None = None):
    find_params = {"stdin": None}
    find_action = ["find", ".", "-type"]
    match type:
        case "dir":
            find_action.append("d")
        case "file":
            find_action.append("f")

    if name:
        find_action.extend(["-iname", name])

    stdout = wrap_cmd(find_action, fm, **find_params)
    if not len(stdout):
        show_error(fm, "Nothing found")
        return

    fzf_action = ["fzf"]
    fzf_params = {"input": stdout}
    selected = wrap_cmd(fzf_action, fm, **fzf_params)
    navigate_path(fm, selected)
