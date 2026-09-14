# dotfiles for @glennr

Using `yadm` to manage my dotfiles. 

To install yadm, and these dotfiles:

```
omarchy pkg add yadm
yadm clone -f https://github.com/glennr/dotfiles.git
yadm restore --staged $HOME
yadm checkout -- $HOME
```

## Working on these files

Edit in `~/src/glennr/dotfiles`, not in `$HOME`. The clone holds only the
managed files, so `git add -A` there cannot pick up anything Omarchy owns.
yadm deploys the same commits into `$HOME`.

| | |
|---|---|
| `dot` | cd to the working clone |
| `dots` | show whether the clone, yadm and `$HOME` agree |
| `dotsync` | refresh the clone from yadm — run before editing |
| `dotdeploy` | send the clone's commits into `$HOME` |

`dotsync` hard-resets the clone, so commit before running it. yadm only
tracks files already added by explicit path; new files in `$HOME` never join
on their own.

## Shell config

`~/.bashrc` sources Omarchy's rc, then loops over `~/.bashrc.d/*.sh`. Numeric
prefixes set the order: `50-worktrees.sh` captures Omarchy's `ga()`/`gd()`
before `90-git.sh` and `91-git-on-roids.sh` claim those names, and
`91-git-on-roids.sh` deliberately overrides some aliases from `90-git.sh`.
