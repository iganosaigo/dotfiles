import os
import shlex
from dataclasses import dataclass

import helpers as h

from ranger.api.commands import Command
from ranger.ext.get_executables import get_executables

h.check_required_bin()


@dataclass
class RgCmd:
    action: list
    stdout: str | None = None
    params: dict | None = None


class rg(Command):
    """
    :rg [opts] [name]
    Using `rg` to search file content recursively in current directory.
    Filtering with `fzf` and preview with `bat`.
    Pressing `Enter` on target will open at line in (neo)vim.
    """

    def execute(self):

        fm = self.fm

        # @dataclass
        # class Cmd:
        #     action: list
        #     stdout: str | None = None
        #     params: dict | None = None

        reqs = h.REQUIRED_BIN

        editor = self.get_editor()
        if editor is None:
            self.fm.notify("(Neo)vim not found", bad=True)
            return

        # Remeber current PWD
        current_pwd = fm.thisdir.path
        if current_pwd == fm.home_path:
            self.fm.notify(
                "Searching from home directory is not allowed",
                bad=True,
            )
            return

        search_pattern = shlex.split(self.rest(1))
        ripgrep = self.build_ripgrep_cmd(reqs["ripgrep"], search_pattern)
        preview = self.build_preview_cmd(reqs["preview"])
        fzf = self.build_fzf_cmd(reqs["fzf"], preview.action)
        awk = self.build_awk_cmd(reqs["awk"])

        ripgrep.stdout = h.wrap_cmd(ripgrep.action, fm, **ripgrep.params)

        if not len(ripgrep.stdout):
            h.show_error(fm, "Nothing found")
            return

        fzf.params = {"input": ripgrep.stdout}
        fzf.stdout = h.wrap_cmd(fzf.action, fm, **fzf.params)
        if len(fzf.stdout) < 2:
            return

        awk.params = {"input": fzf.stdout}
        stdout_awk = h.wrap_cmd(awk.action, fm, **awk.params)
        selected_line = stdout_awk.split()[0]
        full_path = stdout_awk.split()[1].strip()

        file_fullpath = os.path.abspath(full_path)

        self.open_file(editor, selected_line, file_fullpath, current_pwd)

    def get_editor(self):
        if "nvim" in get_executables():
            return "nvim"
        elif "vim" in get_executables():
            return "vim"
        return None

    def build_ripgrep_cmd(self, ripgrep_bin, search_pattern):
        return RgCmd(
            action=[ripgrep_bin, "--line-number"] + search_pattern,
            params={"stdin": None},
        )

    def build_preview_cmd(self, preview_bin):
        return RgCmd(
            action=[
                preview_bin,
                "--theme=gruvbox-dark",
                "--color=always",
                "--number",
                "--style=numbers,changes,rule",
                "--highlight-line={2}",
                "{1}",
            ]
        )

    def build_fzf_cmd(self, fzf_bin, preview_action):
        return RgCmd(
            action=[
                fzf_bin,
                "--exact",
                "--delimiter=:",
                "--preview-window=up,70%,wrap,+{2}+3/2",
                f"--preview={' '.join(preview_action)}",
            ]
        )

    def build_awk_cmd(self, awk_bin):
        return RgCmd(action=[awk_bin, "-F:", '{print "+"$2" "$1}'])

    def open_file(self, editor, selected_line, file_fullpath, current_pwd):
        fm = self.fm

        # Run Editor without changing the directory
        try:
            fm.execute_command(
                f"{editor} {selected_line} {file_fullpath} -c 'normal zz'"
            )
        finally:
            fm.cd(current_pwd)


class rgd(rg):
    def open_file(self, editor, selected_line, file_fullpath, current_pwd):
        fm = self.fm
        file_basename = os.path.basename(file_fullpath)

        if os.path.isdir(file_fullpath):
            fm.cd(file_fullpath)
        else:
            fm.select_file(file_fullpath)

        try:
            fm.execute_command(
                f"{editor} {selected_line} {file_basename} -c 'normal zz'"
            )
        finally:
            fm.cd(current_pwd)


class fzf(Command):
    """
    :fzf [opts]
    Find a path using fzf.
    Argument "opts" add those opt to cmd.
    """

    def execute(self):
        fm = self.fm
        params = {"stdin": None}
        action = ["fzf"]
        opt = self.rest(1)
        if opt:
            opt = opt.split()
            action.extend(opt)

        stdout = h.wrap_cmd(action, fm, **params)
        fzf_file = os.path.abspath(stdout.rstrip("\n"))
        h.navigate_path(fm, fzf_file)


class dir_history(Command):
    """
    :dir_history
    Show history of directories navigation
    """

    def execute(self):
        fm = self.fm
        history = []
        for d in reversed(fm.tabs[fm.current_tab].history.history):
            if d.path not in history:
                history.append(d.path)

        action = ["fzf"]
        params = {"input": "\n".join(history)}
        selected = h.wrap_cmd(action, fm, **params)
        h.navigate_path(fm, selected)


class ff(Command):
    """
    :ff [name]
    Find a file using find.
    If argument "name" provided than search dir with that name.
    """

    def execute(self):
        fm = self.fm
        h.find(fm, "file", self.arg(1))


class fdir(Command):
    """
    :fdir [name]
    Find dirctories from current PWD using find.
    If argument "name" provided than search dir with that name.
    """

    def execute(self):
        fm = self.fm
        h.find(fm, "dir", self.arg(1))
