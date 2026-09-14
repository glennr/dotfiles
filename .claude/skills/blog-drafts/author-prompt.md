# Author prompt template

Fill every `{{FIELD}}`. For a TIL batch, repeat the "Post" block per TIL and keep one worktree per slug.

---

You are drafting a blog post for Glenn Roberts (glenn-roberts.com, Hugo). Work only in the
worktree given. Do not touch master. Commit when done.

## Post

- Type: {{TYPE}}                       (article | til)
- Slug: {{SLUG}}
- Working title: {{TITLE}}
- Angle: {{ANGLE}}
- Worktree: {{WORKTREE}}               (branch gr/{{SLUG}} already exists there)
- File: {{WORKTREE}}/content/posts/{{SLUG}}.md   (frontmatter skeleton; it may also hold an
  untracked draft from an earlier run that died. Treat any such draft as unverified: check every
  claim against the sources, correct or cut, then continue with the steps below)
- Length: {{LENGTH}}

## Sources (read all of these, and nothing else for facts)

{{SOURCES}}

Session transcripts are JSONL under `~/.claude/projects/<dir>/<id>*.jsonl`. Extract the user
and assistant text, skim tool output. Plans are under `~/.claude/plans/`.

## Steps

1. Read `~/src/glennr/style/voice.md` and `~/src/glennr/style/samples/blog.md`. These are the
   writing sample. Blog register: second person, rhetorical question to set up the problem,
   inline links on the natural phrase, opinions grounded in use, production caveats after the
   happy path, spaced hyphen where a dash is needed, never an em dash, no emoji, no bold labels,
   sentence-case headings, lists for anything with more than two parts, paragraphs of 1 to 3
   sentences.
2. Read every source. Note which facts, commands and numbers you can support.
3. Write the draft into the file, keeping the frontmatter and filling `description`. Code
   blocks for commands and config. Link to upstream docs and repos where the source did.
   Public repos you may link: `github.com/glennr/backup`, `github.com/glennr/dotfiles`,
   `github.com/glennr/sync`.
4. Any claim you want to make that the sources do not support: either drop it or leave
   `<!-- TODO: verify: <claim> -->` in place. Never invent a fact, number, name, flag or URL.
5. Load the humanizer skill (Skill tool: `humanizer:humanizer`). It loads instructions rather
   than rewriting for you: apply its file-mode process to the post by hand, prose only.
6. Voice pass: re-read `voice.md`, then edit the file so it reads like the blog sample. Match
   the rate of quirks; parentheses for asides, one hedge then commitment, verdict first.
7. Run `~/.claude/skills/blog-drafts/bin/lint.sh <file>` and fix every hit that is not inside
   a code block or quoted on purpose. Repeat until clean.
8. Commit in the worktree: `git add content/posts/{{SLUG}}.md && git commit -m "draft: {{TITLE}}"`.
   Do not push.

## Constraints

- No device IDs, key material, secrets, bucket names beyond those in the public READMEs, or
  client names.
- Machines may be named (mia, vega, broomhilda, nixserver).
- Do not mention that an AI drafted the post. Write as Glenn, first person.
- Do not edit anything outside the worktree.

## Report back (this is all I see)

- Title and final word count.
- Sources read (paths).
- `TODO: verify` markers left, quoted.
- Lint result and commit hash.
- One line on anything you were unsure about.
