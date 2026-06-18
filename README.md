# dotfiles

A minimal, fast, reproducible macOS dev setup. One git repo is the source of truth;
configs are symlinked into place with GNU stow; a fresh Mac is two commands.

## What's in here

| Tool | Role | Config |
|------|------|--------|
| Homebrew | GUI apps + system CLIs | `Brewfile` |
| mise | runtimes (node/python/go/rust/bun) + global CLIs (pnpm, wrangler, claude-code) | `mise/.config/mise/config.toml` |
| Git | identity, SSH-signed commits, delta pager, global ignore | `git/.gitconfig`, `git/.gitignore` |
| fish | shell | `fish/.config/fish/config.fish` |
| Starship | prompt | `starship/.config/starship.toml` |
| Ghostty | terminal | `ghostty/.config/ghostty/config` |
| AeroSpace | tiling WM | `aerospace/.config/aerospace/aerospace.toml` |
| Zed | editor (+ extensions) | `zed/.config/zed/settings.json` |
| VS Code | editor (mirrors Zed) | `vscode/Library/.../Code/User/settings.json`, `vscode-extensions.txt`, `vscode-theme/` |
| Claude Code | global agent config | `claude/.claude/{settings.json,CLAUDE.md,dotfiles.md}` |
| marks | dir bookmarks (prwd replacement) | `fish/.config/fish/conf.d/marks.fish` |
| SSH | non-secret client config (keys stay out) | `ssh/.ssh/config` |
| bin | personal scripts on `PATH` (e.g. the `zed` launcher wrapper) | `bin/.local/bin/` |
| ripgrep | rg defaults (`--smart-case`) via `$RIPGREP_CONFIG_PATH` | `ripgrep/.config/ripgrep/config` |
| macOS | system preferences (one-shot script, not stowed) | `macos.sh` (`mise run macos`) |
| Tasks | repo automation (link/update/doctor/…) + first-run bootstrap | `mise.toml`, `bootstrap.sh` |

Each top-level folder is a **stow package**: its inner path mirrors `$HOME`, so
`stow zed` creates `~/.config/zed/settings.json -> ~/dotfiles/zed/.config/zed/settings.json`.

Automation lives in **mise tasks** (`mise.toml`), not a Makefile — `make` isn't
guaranteed on a fresh Mac (it comes with the Xcode CLT) and we depend on mise
anyway. List tasks with `mise tasks`; run one with `mise run <task>`.

## New machine

```sh
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh     # Homebrew + Brewfile (installs mise), symlinks configs, mise install, macOS defaults
mise run shell     # one-time: set fish as default shell (asks for sudo)
mise run touchid   # one-time: enable Touch ID for sudo (asks for sudo)
mise run vscode    # install VS Code extensions + the local Tomorrow Night Bright theme
mise run mcp       # optional: register Claude Code MCP servers
```

Then open Zed once — it auto-installs the extensions declared in `settings.json`.

`./bootstrap.sh` installs Homebrew + the Brewfile first (so `mise`, `stow`, etc.
exist), then hands off to mise tasks. It runs a **preflight**: if the Brewfile has
App Store (`mas`) apps, it checks you're signed into the App Store and bails early
with instructions if not — so bootstrap doesn't half-fail on the Bear line.
(Manual check: `mas account`.)

> **macOS defaults** (`mise run macos`, also part of `bootstrap.sh`): runs `macos.sh`, which
> pins key repeat, Finder/Dock behaviour, screenshots → `~/Screenshots` as PNG, etc.
> It's idempotent — safe to re-run. Some changes need a logout/restart to show up.

> **SSH** (`ssh/.ssh/config`): non-secret client config only — **keys never live in
> the repo**. `mise run link` first ensures `~/.ssh` is a real directory (perms 700)
> so stow links just the `config` file into it rather than symlinking the whole
> `~/.ssh`. Machine-specific or sensitive entries go in `~/.ssh/config.local`
> (git-ignored, `Include`d first so it wins). Touch ID for sudo is `mise run touchid`.

> **App Store apps** (Bear): `brew bundle` installs these via `mas`, which needs you
> signed into the App Store first (`mas account` to check). Bear has no Homebrew cask.

> If `mise run link` complains about conflicts, you have real files where symlinks
> should go. Back them up and remove them, or run `stow --adopt <pkg>` to pull the
> existing file into the repo, then `git diff` to review.

## The division of labour (where does a new tool go?)

- **GUI app or general system CLI** → add a line to `Brewfile`, then `brew bundle`.
- **Language runtime or a CLI from npm/pypi/cargo** → add to mise
  `config.toml`, then `mise install`. (Keeps versions pinned and per-project.)
- **A new config file** → drop it in the right stow package, then `mise run relink`.

This keeps the JS toolchain (node, pnpm, bun, wrangler, claude-code) out of brew
and inside mise, so projects can pin their own versions without conflicts.

## How Claude Code maintains this over time

`claude/.claude/CLAUDE.md` tells Claude Code that this repo is the source of truth
and that `~/.config/**` are symlinks into it. So when you ask Claude Code to "add
ripgrep-all" or "bump node to 22 and add the biome CLI globally," it edits the real
file here, runs the right side-effect (`brew bundle` / `mise install`), and commits.
Because the files are symlinks, edits are live immediately and tracked in git.

Two niceties:
- In any Claude Code session, pressing `#` appends an instruction to `CLAUDE.md`.
- Zed's "Claude Agent" (ACP) reads the same `~/.claude/CLAUDE.md`, so the editor
  agent and the CLI share one brain.

## Updating

```sh
cd ~/dotfiles && mise run update   # git pull, brew bundle, mise upgrade, relink
```
