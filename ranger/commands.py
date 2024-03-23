import os
import helpers as h
import shlex

from dataclasses import dataclass
from ranger.api.commands import Command
from ranger.ext.get_executables import get_executables

h.check_required_bin()


class rg(Command):
    """
    :rg [opts] [name]
    Using `rg` to search file content recursively in current directory.
    Filtering with `fzf` and preview with `bat`.
    Pressing `Enter` on target will open at line in (neo)vim.
    """

    def execute(self):

        fm = self.fm

        @dataclass
        class Cmd:
            action: list
            stdout: str | None = None
            params: dict | None = None

        reqs = h.REQUIRED_BIN

        editor = None
        if "nvim" in get_executables():
            editor = "nvim"
        elif "vim" in get_executables():
            editor = "vim"

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

        ripgrep = Cmd(
            action=[reqs["ripgrep"], "--line-number"],
        )
        search_pattern = shlex.split(self.rest(1))
        ripgrep.action.extend(search_pattern)

        preview = Cmd(
            action=[
                reqs["preview"],
                "--theme=gruvbox-dark",
                "--color=always",
                "--number",
                "--style=numbers,changes,rule",
                "--highlight-line={2}",
                "{1}",
            ]
        )

        fzf = Cmd(
            action=[
                reqs["fzf"],
                "--exact",
                "--delimiter=:",
                "--preview-window=up,70%,wrap,+{2}+3/2",
                f"--preview={' '.join(preview.action)}",
            ]
        )

        awk = Cmd(action=[reqs["awk"], "-F:", '{print "+"$2" "$1}'])

        ripgrep.params = {"stdin": None}
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
        file_basename = os.path.basename(full_path)

        # I want to cd within files dir when editor launched.
        if os.path.isdir(file_fullpath):
            fm.cd(file_fullpath)
        else:
            fm.select_file(file_fullpath)

        # Run Editor and when it exits return to previus PWD
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
