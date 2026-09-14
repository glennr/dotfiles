# Track tmux.conf in yadm + self-installing session persistence

## Context

tmux sessions don't survive reboots. `~/.config/tmux/tmux.conf` is a byte-for-byte copy of
Omarchy's stock `/usr/share/omarchy/config/tmux/tmux.conf`, unmodified, with no plugin
manager and no `tmux-resurrect`/`tmux-continuum` anywhere on the machine. Sessions live
only in the tmux server's memory — detaching survives, a reboot doesn't, and nothing on
disk ever recorded them.

Separately, `.config/tmux/tmux.conf` is **not tracked by yadm**. The repo has `.bashrc`,
`.bashrc.d/*`, `.gitconfig`, nvim and VS Code, but no tmux, so any change made now would be
untracked drift on this one machine.

Two outcomes:
1. tmux config managed in the dotfiles repo like everything else.
2. A fresh `yadm clone` on a new machine yields working session persistence with no extra
   steps, and **no non-config files in the repo** — no bootstrap script, no vendored
   plugins, no submodules.

## Decisions taken

| Decision | Choice |
|---|---|
| Bootstrap mechanism | Self-bootstrapping `tmux.conf` — the whole mechanism is config |
| Restore scope | Layout + cwd + scrollback. **No** program restoration |
| `t` alias | **Unchanged.** Keep the session named `Work` instead |
| File structure | **Thin wrapper** that `source-file`s Omarchy's shipped config |

Net result: **the repo gains exactly one file**, `.config/tmux/tmux.conf` (~20 lines), plus
a README edit. No `.bashrc.d` file, no hypr change, no bootstrap script.

## What the reviews changed

Two reviews (a design agent and an adversarial `codex` pass) independently traced the
plugin sources and converged on three corrections to the naive approach:

- **`@resurrect-processes 'false'` is required.** *Omitting* the option does not disable
  program restore — resurrect's `default_proc_list` (`vi vim view nvim emacs man less more
  tail top htop irssi weechat mutt`) is active unless the value is literally `false`.
  Leaving it unset gives the opposite of the chosen restore scope.
- **`TMUX_PLUGIN_MANAGER_PATH` must be pinned before the bootstrap runs.** tpm normally
  sets it in `set_tpm_path()`, which runs *after* the bootstrap. Unset, `install_plugins`
  hits `tpm_path()`'s `FATAL: Tmux Plugin Manager not configured` and aborts silently
  inside `run-shell`. This is why the widely-copied auto-install snippet leaves people
  hitting `prefix + I` once.
- **`@continuum-boot` is out.** It writes `~/.config/systemd/user/tmux.service` with a
  hardcoded `Environment=DISPLAY=:0`, no graphical-session ordering, and no linger. A
  server started before the graphical session leaves restored shells with a stale
  environment.

Codex raised one blocker that **does not apply**: `yadm clone` only checks out tracked
files *missing* from the worktree and leaves differing existing files alone
(`/usr/bin/yadm:857-880`), so a stock Omarchy `tmux.conf` would shadow the tracked one.
But the repo README's install procedure already ends with `yadm checkout -- $HOME`, which
is exactly the remedy yadm's own NOTE recommends. Verified — no change needed beyond
keeping that line and explaining why it matters.

Corrections to claims made earlier in this session: tmux 3.7's `update-environment`
already includes `WAYLAND_DISPLAY`/`DISPLAY`/`SSH_AUTH_SOCK`, and `set-clipboard on` is
OSC 52 rather than `wl-copy`, so the clipboard-breakage concern about a boot-started
server was overstated. `@continuum-boot` is still out, for the ordering reasons above.

## Key environment facts

| | |
|---|---|
| tmux | 3.7c (Arch `tmux 3.7_c-1`); greenfield — no tpm, no `~/.config/tmux/plugins` |
| yadm | 3.5.0, repo `~/.local/share/yadm/repo.git`, `core.worktree=/home/g` |
| Working clone | `~/src/glennr/dotfiles`, remotes `origin` (GitHub SSH) + `yadm` (local) |
| Deploy direction | clone → `dotdeploy` → yadm/`$HOME`. **Never** the reverse |
| `dotsync` | **hard-resets the clone** — commit before running |
| `dotdeploy` | `yadm merge --ff-only FETCH_HEAD` — deploys stay linear |

## Implementation

### 1. Create the wrapper in the working clone

New file `~/src/glennr/dotfiles/.config/tmux/tmux.conf`. Nothing is copied from `$HOME` —
the wrapper replaces the stock file rather than extending a copy of it.

```tmux
# Omarchy's shipped config. Tracked as a wrapper rather than a copy: package
# upgrades land directly, and migrations that rewrite the stock file no-op here.
# -q so this file still works on a machine without Omarchy.
source-file -q /usr/share/omarchy/config/tmux/tmux.conf

# ─── Plugins ──────────────────────────────────────────────────────────────────
# Keep this block last. tmux-continuum prepends its auto-save hook to
# status-right, so it must run after the stock config sets status-right above.

# Pin the install dir. tpm sets this itself, but only once tpm/tpm runs — which
# is after the bootstrap below, and the bootstrap needs it already resolved or
# install_plugins aborts with "FATAL: Tmux Plugin Manager not configured".
set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.config/tmux/plugins/"

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Layout, working directories and scrollback come back. Nothing is re-executed:
# 'false' switches off resurrect's default program list, which is ON unless
# explicitly disabled.
set -g @resurrect-processes 'false'
set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '5'

# Self-bootstrap. A fresh clone has no plugins, so the first tmux start fetches
# them. No -b, so run-shell blocks this command queue until it finishes. The
# test -x guard re-runs install_plugins whenever a plugin is missing, so a
# partial install (tpm cloned, a plugin clone failed) self-heals on next start.
run-shell -E 'p="$HOME/.config/tmux/plugins"; mkdir -p "$p" && \
  { test -x "$p/tpm/tpm" || GIT_TERMINAL_PROMPT=0 git clone --depth 1 \
      https://github.com/tmux-plugins/tpm "$p/tpm"; } && \
  "$p/tpm/bin/install_plugins" >/dev/null && "$p/tpm/tpm"'
```

Why this works first-try on a fresh machine: `run-shell` without `-b` returns
`CMD_RETURN_WAIT`, blocking the config queue, so the clone and install complete before tpm
sources the plugins. The `@plugin`/`@resurrect-*`/`@continuum-*` options are all set
before that, so both plugins read them at source time — no settings race, no reload. tpm
discovers plugins by awk-scanning the config *text* for `^[ \t]*set(-option)? +-g +@plugin`,
and those lines live in this wrapper, which is the file tmux loads. Use
`bin/install_plugins`, not `bindings/install_plugins` — the latter re-enters config parse
from inside a blocked config parse.

### 2. Deploy

```bash
dotsync                                   # start clean; hard-resets, so do this FIRST
mkdir -p ~/src/glennr/dotfiles/.config/tmux
# ...write the wrapper above, and the README edits from step 4...
git -C ~/src/glennr/dotfiles add .config/tmux/tmux.conf README.md
git -C ~/src/glennr/dotfiles commit -m "tmux: track config, self-bootstrap tpm + resurrect + continuum"

# REQUIRED: the untracked $HOME copy would block the merge with
#   "untracked working tree files would be overwritten by merge"
mv ~/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf.pre-yadm

dotdeploy
git -C ~/src/glennr/dotfiles push origin master
```

Do **not** `yadm add` in `$HOME`. That commits on the yadm side, diverges from the clone,
permanently breaks `dotdeploy`'s `--ff-only`, and gets dragged back by `dotsync`'s hard
reset. The flow stays one-way.

### 3. Session naming — why the alias needs no change

`tmux attach || tmux new -s Work` stays exactly as Omarchy ships it, and so does the
`SUPER + ALT + RETURN` binding (which resolves through
`/usr/share/omarchy/bin/omarchy-launch-terminal-tmux`, a package-owned script that can't be
tracked anyway).

This works because of how `scripts/restore.sh` behaves: when the snapshot contains a
session named `Work` and the server has exactly one pane, resurrect **replaces that startup
pane in place** rather than leaving a stray session. Other saved sessions restore under
their own names.

The one rule to follow: **keep your primary session named `Work`.** If the snapshot has no
`Work` session, the bootstrap one is left behind empty — resurrect's cleanup path
(`handle_session_0()`) only kills a session literally named `0`. Fix if it happens:
`tmux kill-session -t Work`.

Also avoid interacting with the terminal for the first second or two after a cold start —
restore runs in the background after a fixed 1 s sleep, and the single-pane replacement can
kill a command started immediately after launch.

### 4. README.md

The repo README already has `## Working on these files` and `## Shell config`. Add:

- A `## tmux` section: the wrapper structure and why (`source-file` the package config, so
  Omarchy upgrades land for free); that the plugin block self-bootstraps so a bare
  `yadm clone` needs no `prefix + I`; that `@resurrect-processes 'false'` is deliberate
  because unset means *enabled*; that the primary session must stay named `Work`; and that
  `~/.config/tmux/plugins/` and `~/.local/share/tmux/resurrect/` are not tracked and
  shouldn't be.
- A note on the existing install block that `yadm checkout -- $HOME` is now load-bearing —
  Omarchy ships its own `~/.config/tmux/tmux.conf`, and plain `yadm clone` leaves an
  existing differing file in place.
- A `### Omarchy drift` subsection with the step-5 procedure.

### 5. Omarchy drift procedure

The wrapper shrinks this problem but doesn't erase it. Migrations are guarded on
`$HOME/.config/tmux/tmux.conf`, which is now the wrapper — `sed -i` substitutions and
marker-anchored inserts (e.g. after `# Pane Controls`) find nothing and no-op, but a
future migration that *appends* will append past the `run-shell` line. All three existing
tmux migrations already have markers in `~/.local/state/omarchy/migrations/`, so they
won't re-run here.

When `yadm status --short` shows ` M .config/tmux/tmux.conf` after an `omarchy update`:

```bash
yadm diff -- .config/tmux/tmux.conf       # read exactly what the migration did
dotsync                                   # safe only with no uncommitted clone work
cp -a ~/.config/tmux/tmux.conf ~/src/glennr/dotfiles/.config/tmux/tmux.conf
git -C ~/src/glennr/dotfiles diff         # should be ONLY the migration's edit
#   move any appended lines ABOVE the "─── Plugins ───" header so the
#   run-shell bootstrap stays last
git -C ~/src/glennr/dotfiles commit -am "tmux: absorb omarchy migration <id>"
yadm checkout -- .config/tmux/tmux.conf   # REQUIRED before the ff-only merge
dotdeploy
```

The `yadm checkout --` is the non-obvious part and is not optional: git's `twoway_merge`
calls `verify_uptodate()` against the index and rejects a dirty path even when the working
tree already matches the incoming commit. It's lossless here — the content being discarded
is byte-identical to the commit just made.

`omarchy-refresh-tmux` (Update > Config > Tmux) overwrites the wrapper wholesale with the
stock file. It's user-invoked only. Recovery: `yadm checkout -- .config/tmux/tmux.conf`.

## Verification

### A. Bootstrap, in isolation — run this before touching `$HOME`

```bash
T=/tmp/claude-1000/-home-g/*/scratchpad/tmuxfresh
rm -rf "$T"; mkdir -p "$T/.config/tmux"
cp ~/src/glennr/dotfiles/.config/tmux/tmux.conf "$T/.config/tmux/tmux.conf"
run() { env -i HOME="$T" TMUX_TMPDIR="$T" PATH=/usr/bin:/bin TERM=xterm-256color \
        tmux -L fresh "$@"; }

run new-session -d && sleep 25            # allow three git clones
ls "$T/.config/tmux/plugins"              # EXPECT: tpm tmux-continuum tmux-resurrect
run show-options -g status-right          # EXPECT: leading #(.../continuum_save.sh)
run list-keys | grep -c install_plugins   # EXPECT: 1  (tpm bindings live)
run kill-server; rm -rf "$T"
```

The `status-right` check is decisive: continuum's `add_resurrect_save_interpolation()` only
ran if tpm sourced the plugin, which only happened if the install completed *inside* the
same config parse. If that shows, the first start is genuinely self-sufficient.

Worth also running once against a copy with the `set-environment -g
TMUX_PLUGIN_MANAGER_PATH` line deleted — expect only `tpm` to appear and `status-right`
unmodified, confirming why the pin is needed.

### B. Real persistence

```bash
t                                         # session should be named Work
echo "RESURRECT-MARKER-$(date +%s)"       # distinctive scrollback
# prefix C-s  -> force a save now instead of waiting 5 minutes
ls -l ~/.local/share/tmux/resurrect/      # last -> tmux_resurrect_<ts>.txt + pane_contents.tar.gz

tmux kill-server && t                     # fast proxy: continuum keys off server start, not boot
tmux ls                                   # EXPECT: Work, no stray session
# prefix [ and scroll -> find RESURRECT-MARKER      (proves capture-pane-contents)
ps -o comm= -t "$(tmux display -p '#{pane_tty}')"  # EXPECT: bash only (proves processes 'false')
```

Then a real `systemctl reboot` and repeat the last four checks.

### C. Deployment sanity

```bash
dots                                                # clone/yadm/$HOME agree
yadm ls-files .config/tmux                          # -> .config/tmux/tmux.conf
diff ~/src/glennr/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf   # empty
rm ~/.config/tmux/tmux.conf.pre-yadm                # once verified
```

## Caveats to know about

- **Saves ride the status bar.** Continuum triggers saves from `status-right` redraws, not
  a timer. No attached client with a rendering status bar means no saves — "every 5
  minutes" isn't a durability guarantee. Anything that replaces `status-right` after
  continuum loads also removes the trigger.
- **First boot may not restore.** `@continuum-restore-max-delay` is 10 s; the initial git
  clones will usually exceed it, so no restore is attempted on that run. Harmless — there's
  nothing saved yet. Don't raise the value: a `prefix q` reload inside the window triggers
  a *second* restore and duplicates windows.
- **Scrollback capture is bulk work.** `@resurrect-pane-contents-area` defaults to `full`
  and the stock config sets `history-limit 50000`. If saves visibly stutter, set it to
  `'visible'`. Captured scrollback also persists terminal output to disk in
  `~/.local/share/tmux/resurrect/` — one `pane_contents.tar.gz`, rewritten in place.
- **The bootstrap runs remote code.** First tmux start on a new machine clones tpm and two
  plugins from GitHub, unpinned. HTTPS protects transport, not upstream changes, and
  different machines can get different revisions.
- **No network on first start** → the clone fails, `&&` short-circuits, and the error
  surfaces in a pane. tmux still starts on the stock config and the next start retries.
