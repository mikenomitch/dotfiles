# Global instructions (apply to every project)

Keep this file short. It loads into every session. Project-specific rules belong
in that project's own `CLAUDE.md`. Anything only *sometimes* relevant belongs in a
skill, not here.

## General

- Agree or disagree directly, then move on. Skip filler like "you're absolutely right."
- Bring opinions, e.g. "recommend B because x, y, z." Present options when prudent.
- Default to bullets and short answers. Expand to prose only when asked.
- Link to sources when appropriate.

## Code, git, and testing

- **STOP and confirm before committing, pushing, or creating/updating PRs.** Do not
  assume prior approval continues to apply.
- **Never commit directly to main/master unless asked.** Use a workspace (worktree) by
  default for new work. Use a branch if checking out a PR or already on a non-main branch.
- After a series of edits, run the typecheck/build and fix any errors at the source
  (no casting to suppress them). Prefer running single tests over the whole suite.
- Match existing patterns in the file before introducing new ones. Prefer inlining over
  premature abstraction.
- Prefer minimal, well-commented config over clever or sprawling config. Comments
  explain why (and what only when something might be confusing).
- Minimize new dependencies unless agreed upon. Include lockfiles in any commit that
  changes dependencies.
- Keep commit messages short and imperative: "add usage example to README", not
  "feat(docs): add usage example".
- Prefer the gh CLI for PRs and issues. When writing a PR or issue, follow the
  `pull-requests` skill.

## Writing

- When writing or editing prose, docs, or any human-readable copy, follow the
  `writing` skill.

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

For **new projects only** — always defer to a project's existing setup or lockfile:

- **Backend:** Rust.
- **Frontend language:** TypeScript.
- **Static sites:** Astro.
- **UI framework:** Solid-JS by default. React is fine when it genuinely fits
  better (e.g. a library or ecosystem piece that only React has).
- **Interactive / SPA-like apps:** TanStack (Router / Query / Start).
- **Styling:** Tailwind.
- **Hosting:** Cloudflare Workers.

## Keeping my setup reproducible (dotfiles + editors)

All my machine/tool config lives in **`~/dotfiles`** (a git repo, stow-symlinked
into `~/.config/**` and `~/.claude/**`), and I keep **Zed and VS Code in sync**.

**Read `~/.claude/dotfiles.md` before** you change any tool or editor configuration,
install/remove a tool, or touch anything under `~/.config`, `~/.claude`, the
`Brewfile`, mise config, or editor settings. That file has the rules for editing the
real file in place (not the symlink), running the right side effect, committing, and
mirroring settings across Zed and VS Code.
