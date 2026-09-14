---
name: blog-drafts
description: Use when the user asks to find, harvest, draft, or batch-write blog posts or TILs from recent activity (git commits, Obsidian notes, Claude sessions, plans), or asks what is worth blogging about, or wants drafts fanned out across branches and worktrees in glennr/blog
---

# Blog drafts

Turn recent work into draft posts on `gr/<slug>` branches of `~/src/glennr/blog`, one worktree
each, written in Glenn's voice, tracked in the vault note `notes/blog backlog.md`.

Principle: the backlog note is the source of truth, the branch is the deliverable, and nothing
in a draft may come from anywhere but the listed sources.

## Tools

All under `~/.claude/skills/blog-drafts/bin/` (deployed by yadm from `glennr/dotfiles`).

| Command | Does |
|---|---|
| `harvest.sh [--since DATE] [--stamp]` | Markdown digest of commits, vault notes, plans and session openers since DATE (default: last stamp, else 7 days) |
| `newpost.sh <slug> [--til] [--title T] [--tags a,b]` | Branch `gr/<slug>` off master, worktree `.worktrees/<slug>`, post skeleton. Idempotent |
| `lint.sh <file>...` | Voice and AI-tell lint (dashes, emoji, bold labels, not-X-but-Y, stock words, title case). Runs vale if installed. Exit 1 on hits |
| `status.sh` | Every draft branch: file, words, lint, last commit |

Each prints `--help`.

## Workflow

1. Harvest. Run `harvest.sh`. Read the digest and pick candidates: something was non-obvious,
   cost time, or changed a decision. Skip anything with no lesson.
2. Backlog. Add one row per candidate to `notes/blog backlog.md` (slug, type, angle, sources,
   status `harvested`). Commit the vault. Sources are file paths, commit hashes, plan names or
   session id prefixes; the author reads only those.
3. Branches. `newpost.sh` per slug. Commit `.gitignore` if `.worktrees/` is new.
4. Fan out. One subagent per article, one per TIL batch of 3 to 6 (group by theme).
   Build each prompt from `author-prompt.md`: fill every `{{FIELD}}`, keep the steps.
   Dispatch in parallel with the Agent tool. Waves of about 7 keep it manageable.
5. Collect. Read each report. `status.sh`. Anything with lint hits or `TODO: verify` markers
   goes back to its agent with the note, or gets fixed by hand.
6. Update the backlog rows to `drafted`, commit the vault, and hand the branch list to Glenn.
   He reviews in the worktree and flips `draft: false` when publishing.

## Post conventions

- Path `content/posts/<slug>.md`, frontmatter: title, description, date (`+10:00`), `draft: true`,
  categories, tags. TILs: title starts `TIL:`, category `til`, 150 to 400 words.
  Articles: 600 to 1500 words, category from existing ones (`development`, `troubleshooting`,
  `DevOps`, `Security`).
- Voice comes from `~/src/glennr/style/voice.md` plus `samples/blog.md`. The humanizer pass
  runs first, the voice pass second, then `lint.sh`.
- Machines by name is fine (mia, vega, broomhilda). No device IDs, keys, bucket names not
  already in a public README, or paths that reveal client data.
- The author never states a fact it did not read. Unsupported detail becomes
  `<!-- TODO: verify: ... -->` and is reported back.

## Common mistakes

| Mistake | Fix |
|---|---|
| Agent drafts from memory of the topic | Prompt lists sources by path; the agent's report names which it read |
| Humanizer strips the voice too | Voice pass runs after humanizer, with `voice.md` as the writing sample |
| Draft on master | `newpost.sh` always makes the branch; check `git -C <worktree> branch --show-current` |
| Backlog says drafted but branch is empty | Only mark `drafted` after `status.sh` shows a commit and a clean lint |
| Publishing by accident | `draft: true` stays until Glenn flips it; the CI only deploys master |
| Authors die on a rate limit (HTTP 429, "session limit") | Nothing is lost: skeletons are untracked, worktrees intact. `status.sh` shows which branches have no draft commit; relaunch only those with the same prompts once the window resets |
| Eleven agents at once trip the session limit | Waves of 5 to 7, and launch the next wave only after the previous reports |
| Relaunched author trusts the dead author's draft | The prompt says any pre-existing draft is unverified; the report should list what it corrected |
| "Humanizer ran" but nothing changed | The skill loads instructions; the author applies them by hand. Ask for the removed tells in the report |
| Author inflates a TIL to hit the floor | Length is a ceiling for TILs; a 65-word TIL is fine when the source is one fact |
