# Global instructions (apply to every project)

Keep this file short — it loads into every session. Project-specific rules belong
in that project's own `CLAUDE.md`.

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

## My shell aliases & abbreviations (so commands/history don't confuse you)

These are **fish interactive shortcuts only** — they do not exist in scripts or
non-interactive shells. When you write scripts or run commands yourself, use the
canonical binaries (`grep`, `find`, `cat`, `cd`), not these. This list is so you can
*read* my commands and history correctly.

Some standard commands are remapped in my interactive shell to modern tools:
`ls`/`ll`/`lt` → eza, `cd` → zoxide (`z`), `find` → fd, `grep` → rg, `top` → btop,
`du` → dust. **`cat` is plain `cat`** (no longer aliased) — `bat` is its own command.

- git: `gs` status · `gd` diff · `gco` checkout · `gp` push · `gpl` pull · `gl` log · `lg` log --oneline --graph --decorate
- pnpm: `pn` pnpm · `pnx` pnpm dlx · `pi` pnpm install · `pd` pnpm dev
- `wr` wrangler · `cc` claude (Claude Code)
- dir bookmarks: `mark`/`jump`/`marks`/`unmark`/`setdef` (prwd-compat: `sw`/`gw`/`lw`)

## Style

- Be concise and direct. Lead with the change/answer; skip preamble.
- Match existing patterns in the file before introducing new ones.
- Prefer minimal, well-commented config over clever or sprawling config.

## Dotfiles — how to keep my setup reproducible (IMPORTANT)

All machine/tool configuration lives in **`~/dotfiles`**, a git repo whose files are
symlinked into place with **GNU stow**. So `~/.config/**` and `~/.claude/**` are
symlinks that point *into* `~/dotfiles`.

When you change any tool's configuration:

1. **Edit the file in place** (e.g. `~/.config/mise/config.toml`). Because it's a
   symlink, you're editing the real file inside `~/dotfiles` — never create a
   second, divergent copy and never dereference the symlink.
2. **Apply side effects:**
   - changed `~/dotfiles/Brewfile` → run `brew bundle --file ~/dotfiles/Brewfile`
   - changed mise config → run `mise install`
   - added a brand-new config file/dir → `cd ~/dotfiles && stow <package>` to link it
3. **Commit** in `~/dotfiles` with a clear message describing what changed and why.

When adding a new tool: GUI apps and system CLIs go in the **Brewfile**; language
runtimes and language-installed CLIs go in **mise** (`~/.config/mise/config.toml`).
Keep everything captured in the repo so a fresh Mac is `git clone` + `make bootstrap`.

## Editors: keep Zed and VS Code in sync

I use both Zed and VS Code and want them to feel the same. When I ask you to change
an editor setting, apply the equivalent change to **both** unless I say otherwise.
The config files are:

- Zed: `~/.config/zed/settings.json` (+ themes in `~/.config/zed/themes/`)
- VS Code: `~/Library/Application Support/Code/User/settings.json`, with the
  extension list in `~/dotfiles/vscode-extensions.txt` and the shared theme in
  `~/dotfiles/vscode-theme/`.

Setting equivalents to keep aligned: theme (Tomorrow Night Bright), Sublime
keybindings, spaces with tab size 2 (Go stays on tabs via gofmt in both), format
on save with Biome for JS/TS/CSS/JSON and Ruff for Python, fish as the integrated
terminal, telemetry off, and the same font. When I add a language extension to one,
add the counterpart to the other (e.g. Zed `toml` ↔ VS Code `tamasfe.even-better-toml`,
Zed `biome` ↔ `biomejs.biome`, Zed `ruff` ↔ `charliermarsh.ruff`). After editing the
VS Code extension list, remind me to run `make vscode`.
