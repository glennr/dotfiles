# dotfiles for @glennr

These dotfiles use `yadm` and target a Bash-based Linux desktop. They work on
Ubuntu and other distributions, but they include optional integration with the
packages on my current system. Read the assumptions before you install them.

## Install

Install `yadm` with your distribution package manager:

```
sudo apt install yadm     # Debian, Ubuntu
omarchy pkg add yadm      # Omarchy
sudo pacman -S yadm       # Arch
```

Then clone the repository:

```
yadm clone -f --bootstrap git@github.com:glennr/dotfiles.git
```

The bootstrap script writes tracked files over existing files in `$HOME`.
This matters when a package already owns a path such as
`~/.config/tmux/tmux.conf`. Back up local changes first.

## Assumptions

This setup assumes that Bash is your login shell and reads `~/.bashrc`.
It also expects `git`, `tmux`, and `yadm`. Package updates can replace files in
paths that this repository tracks. Review those changes before you commit them.

Some files use optional paths from my current distribution. Missing tmux paths
are ignored. Bash skips its distribution rc file when that file is absent.
The rest of `~/.bashrc`, including `~/.bashrc.d/*.sh`, works without it.

## Manage files

Edit files directly in `$HOME`. yadm uses `$HOME` as its work tree, so there
are no symlinks or duplicate files.

`~/.gitignore` ignores almost everything in `$HOME`. New files need an explicit
`-f`, which keeps `yadm add -A` from adding package files by accident. Use the
`df` command for normal work:

| Command | Result |
|---|---|
| `df status` | Show changed tracked files. |
| `df add FILE...` | Start tracking files. |
| `df commit -m "..."` | Commit all tracked changes. |
| `df diff` / `df log` / `df push` | Diff, log, or push. |

`df add` accepts files only. It refuses directories, `.` and flags.
`df commit` uses `-a`, so it commits tracked changes only. For other
commands, use `yadm` directly. Do not run `yadm add -A`.

`yadm status` does not show untracked files. Tools that honor `.gitignore`
outside a Git work tree can also treat most of `$HOME` as ignored.

## tmux

`.config/tmux/tmux.conf` optionally sources a distribution tmux file, then
loads tpm, tmux-resurrect, and tmux-continuum. If the optional file is absent,
tmux continues with this repository's configuration.

The first tmux start clones and installs the plugins in
`~/.config/tmux/plugins/`. tmux saves sessions every five minutes and restores
them when its server starts. It restores layouts, directories, and scrollback,
but it does not restart programs. Neither the plugins nor saved session data in
`~/.local/share/tmux/resurrect/` are tracked.

The plugin install downloads current code from GitHub. It needs network access
on the first tmux start.

If a package update edits `.config/tmux/tmux.conf`, inspect the change before
you commit it:

```
df diff -- .config/tmux/tmux.conf
```

If you do not want the package edit, restore the tracked version:

```
yadm checkout -- .config/tmux/tmux.conf
```

On my current distribution, its tmux refresh command overwrites this wrapper.
Run the same restore command after that operation.
