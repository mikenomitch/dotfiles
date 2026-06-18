# Global instructions (apply to every project)

Keep this file short. It loads into every session. Project-specific rules belong
in that project's own `CLAUDE.md`.

## General

- Agree or disagree directly, then move on. Skip filler like "you're absolutely right."
- Bring opinions, e.g. "recommend B because x, y, z." Present options when prudent.
- Be concise. Avoid long walls of text.
- Link to sources when appropriate.

## Code, git, and testing

- Write maintainable code over clever code. Leave codebases better than you found them.
- Match existing patterns in the file before introducing new ones.
- Prefer minimal, well-commented config over clever or sprawling config.
- Prefer inlining over premature abstraction.
- Comments explain why (and what only when something might be confusing).
- Fix type errors at the source. No casting to suppress them.
- Minimize new dependencies unless agreed upon. Include lockfiles in any commit that changes dependencies.
- Keep commit messages short and imperative: "add usage example to README", not "feat(docs): add usage example".
- Do not commit directly to main/master unless asked. Use a workspace (worktree) by default for new work. Use a branch if checking out a PR or already on a non-main branch.
- STOP and confirm before committing, pushing, or creating/updating PRs. Do not assume prior approval continues to apply.
- Prefer the gh CLI for PRs and issues.
- Use short sentences and bullet points in PR/issue descriptions. No markdown headers unless asked.
- Do not list changed files in a PR. The diff already shows that.

PRs follow this structure:

- Short opening sentence describing the fix or feature.
- Explain the issue with concrete context.
- (optional) Show real-world data or code demonstrating the problem.
- Bullet points showing the major functional changes.
- Code snippet showing the user-facing result (if applicable).
- Brief mention of docs, tests, etc. as applicable.

## Docs and writing

- Act as my editor, not my replacement. Preserve the original voice and structure. Keep edits small unless asked otherwise.
- Use imperative mood, American English.
- Lead with the problem or context before the solution. Explain the why, not just the what.
- Use "we" for collaboration, "you" to address the reader.
- Keep paragraphs to 2-5 sentences.
- Prefer bullet points over numbered lists unless order matters.
- Be direct and opinionated. Acknowledge tradeoffs honestly.
- Reframe complex points to aid comprehension. Use rhetorical questions sparingly.
- Link liberally to sources, docs, and references.
- Prefer AP style unless the project has an existing convention.
- Avoid marketing speak: "perfect for", "empowers you to", "modernization".
- Avoid LLM tells: "not X but Y", many sentence fragments in a row, grandiose but vague bold claims.
- Avoid both em-dashes and semicolons.

## My environment

- **OS:** macOS (Apple Silicon), Homebrew at `/opt/homebrew`.
- **Shell:** fish. Write interactive snippets in fish syntax. Write committed
  scripts with a `#!/usr/bin/env bash` shebang.
- **Runtimes:** managed by **mise**, not nvm/pyenv/brew. Use `mise` to add or pin
  versions. Node CLIs may run under a mise-managed Node.
- **JS package manager:** **pnpm** by default. Do **not** use `npm`/`yarn` unless a
  repo's lockfile says otherwise. (`bun` only if a project opts in.)
- **Cloudflare:** `wrangler` for Workers. Prefer `wrangler.jsonc` over TOML and a
  recent `compatibility_date`. Treat your built-in knowledge of wrangler flags as
  possibly stale, so check current docs before writing wrangler config.
- **Editor:** Zed. **Terminal:** Ghostty. **WM:** AeroSpace.

## My default stack

Reach for these unless a project's existing setup or lockfile says otherwise:

- **Backend:** Rust.
- **Frontend language:** TypeScript.
- **Static sites:** Astro.
- **UI framework:** Solid-JS by default. React is fine when it genuinely fits
  better (e.g. a library or ecosystem piece that only React has).
- **Interactive / SPA-like apps:** TanStack (Router / Query / Start).
- **Styling:** Tailwind.
- **Hosting:** Cloudflare Workers.

## My shell aliases & abbreviations (so commands/history don't confuse you)

These are **fish interactive shortcuts only**. They do not exist in scripts or
non-interactive shells. When you write scripts or run commands yourself, use the
canonical binaries (`grep`, `find`, `cat`, `cd`), not these. This list is so you can
*read* my commands and history correctly.

Some standard commands are remapped in my interactive shell to modern tools:
`ls`/`ll`/`lt` → eza, `cd` → zoxide (`z`), `find` → fd, `grep` → rg, `top` → btop,
`du` → dust. **`cat` is plain `cat`** (no longer aliased). `bat` is its own command.

- git: `gs` status · `gd` diff · `gco` checkout · `gp` push · `gpl` pull · `gl` log · `lg` log --oneline --graph --decorate
- git rebase/reset onto upstream: `gro` (fetch + rebase onto origin/<branch>) · `greset` (fetch + hard-reset to origin/<branch>, destructive)
- pnpm: `pn` pnpm · `pnx` pnpm dlx · `pi` pnpm install · `pd` pnpm dev
- `wr` wrangler · `cc` claude (Claude Code)
- `killport <port>` kill the process listening on a TCP port (e.g. `killport 4000`)
- dir bookmarks: `mark`/`jump`/`marks`/`unmark`/`setdef` (prwd-compat: `sw`/`gw`/`lw`)

## Keeping my setup reproducible (dotfiles + editors)

All my machine/tool config lives in **`~/dotfiles`** (a git repo, stow-symlinked
into `~/.config/**` and `~/.claude/**`), and I keep **Zed and VS Code in sync**.

**Read `~/.claude/dotfiles.md` before** you change any tool or editor configuration,
install/remove a tool, or touch anything under `~/.config`, `~/.claude`, the
`Brewfile`, mise config, or editor settings. That file has the rules for editing the
real file in place (not the symlink), running the right side effect, committing, and
mirroring settings across Zed and VS Code.
