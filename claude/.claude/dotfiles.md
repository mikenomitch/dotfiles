# Reproducible setup: dotfiles + editors

**When to read this:** any time you're about to change configuration on this
machine — editing a tool's config, installing or removing a tool, or touching
anything under `~/.config`, `~/.claude`, the `Brewfile`, mise config, or editor
(Zed / VS Code) settings. It explains how my dotfiles work so edits stay captured
in git, and how I keep my two editors in sync. (Referenced from `~/.claude/CLAUDE.md`.)

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
   - added a brand-new config file/dir → `cd ~/dotfiles && stow <package>` (or
     `mise run relink`) to link it
3. **Commit** in `~/dotfiles` with a clear message describing what changed and why.

When adding a new tool: GUI apps and system CLIs go in the **Brewfile**; language
runtimes and language-installed CLIs go in **mise** (`~/.config/mise/config.toml`).
Keep everything captured in the repo so a fresh Mac is `git clone` + `./bootstrap.sh`.

Repo automation lives in **mise tasks** (`~/dotfiles/mise.toml`), not a Makefile —
list them with `mise tasks`; common ones are `mise run relink`, `mise run update`,
`mise run doctor`.

## Editors: keep Zed and VS Code in sync

I use both Zed and VS Code and want them to feel the same. When I ask you to change
an editor setting, apply the equivalent change to **both** unless I say otherwise.
The config files are:

- Zed: `~/.config/zed/settings.json` (+ keymap in `~/.config/zed/keymap.json` and
  themes in `~/.config/zed/themes/`)
- VS Code: `~/Library/Application Support/Code/User/settings.json`, with the
  extension list in `~/dotfiles/vscode-extensions.txt` and the shared theme in
  `~/dotfiles/vscode-theme/`.

Setting equivalents to keep aligned: theme (Tomorrow Night Bright), Sublime
keybindings, spaces with tab size 2 (Go stays on tabs via gofmt in both), format
on save with Biome for JS/TS/CSS/JSON and Ruff for Python, fish as the integrated
terminal, telemetry off, and the same font (Fira Code, ligatures off). When I add a
language extension to one, add the counterpart to the other (e.g. Zed `toml` ↔ VS
Code `tamasfe.even-better-toml`, Zed `biome` ↔ `biomejs.biome`, Zed `ruff` ↔
`charliermarsh.ruff`). After editing the VS Code extension list, remind me to run
`mise run vscode`.
