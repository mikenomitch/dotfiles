# Global instructions (apply to every project)

Keep this file short — it loads into every session. Project-specific rules belong
in that project's own `CLAUDE.md`.

## Style

- Be concise and direct. Lead with the change/answer; skip preamble.
- Match existing patterns in the file before introducing new ones.
- Prefer minimal, well-commented config over clever or sprawling config.

## My environment

- **OS:** macOS (Apple Silicon), Homebrew at `/opt/homebrew`.
- **Shell:** fish. Write interactive snippets in fish syntax; write committed
  scripts with a `#!/usr/bin/env bash` shebang.
- **Runtimes:** managed by **mise**, not nvm/pyenv/brew. Use `mise` to add or pin
  versions. Node CLIs may run under a mise-managed Node.
- **JS package manager:** **pnpm** by default. Do **not** use `npm`/`yarn` unless a
  repo's lockfile says otherwise. (`bun` only if a project opts in.)
- **Cloudflare:** `wrangler` for Workers; prefer `wrangler.jsonc` over TOML and a
  recent `compatibility_date`. Treat your built-in knowledge of wrangler flags as
  possibly stale — check current docs before writing wrangler config.
- **Editor:** Zed. **Terminal:** Ghostty. **WM:** AeroSpace.

## My default stack

Reach for these unless a project's existing setup or lockfile says otherwise:

- **Backend:** Rust.
- **Frontend language:** TypeScript.
- **Static sites:** Astro.
- **UI framework:** Solid-JS by default; React is fine when it genuinely fits
  better (e.g. a library or ecosystem piece that only React has).
- **Interactive / SPA-like apps:** TanStack (Router / Query / Start).
- **Styling:** Tailwind.
- **Hosting:** Cloudflare Workers.

## My shell aliases & abbreviations (so commands/history don't confuse you)

These are **fish interactive shortcuts only** — they do not exist in scripts or
non-interactive shells. When you write scripts or run commands yourself, use the
canonical binaries (`grep`, `find`, `cat`, `cd`), not these. This list is so you can
*read* my commands and history correctly.

Some standard commands are remapped in my interactive shell to modern tools:
`ls`/`ll`/`lt` → eza, `cd` → zoxide (`z`), `find` → fd, `grep` → rg, `top` → btop,
`du` → dust. **`cat` is plain `cat`** (no longer aliased) — `bat` is its own command.

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
