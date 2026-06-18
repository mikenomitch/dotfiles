# =============================================================================
# Brewfile  —  run with:  brew bundle --file=~/dotfiles/Brewfile
# Language runtimes + their CLIs (node, pnpm, bun, wrangler, claude-code)
# are intentionally NOT here — those live in mise (~/.config/mise/config.toml)
# so versions are pinned per-project and reproducible.
# =============================================================================

# ---- Taps -------------------------------------------------------------------
tap "nikitabobko/tap"        # AeroSpace

# ---- Core dev toolchain -----------------------------------------------------
brew "git"                   # newer than Apple's system git
brew "mise"                  # runtime + env + task manager (replaces asdf/nvm/direnv)
brew "gh"                    # GitHub CLI
brew "stow"                  # symlink farm manager — links this repo into $HOME

# ---- Shell + prompt ---------------------------------------------------------
brew "fish"                  # interactive shell (Rust core, fast, batteries-included)
brew "starship"              # cross-shell prompt (single starship.toml, portable)

# ---- Modern CLI core (the big quality-of-life upgrade) ----------------------
brew "eza"                   # ls
brew "bat"                   # cat
brew "ripgrep"               # grep  (rg)
brew "fd"                    # find
brew "zoxide"                # smart cd (z)
brew "fzf"                   # fuzzy finder
brew "git-delta"             # git diff pager (delta)
brew "jq"                    # JSON
brew "yq"                    # YAML/JSON/TOML
brew "btop"                  # htop
brew "dust"                  # du
brew "sd"                    # sed
brew "tealdeer"              # tldr (fast)
brew "uv"                    # Python package/venv manager (pairs with Ruff; fast pip/venv)
brew "xh"                    # HTTPie-style HTTP client (Rust)
brew "mkcert"                # local HTTPS certs
brew "nss"                   # needed by mkcert for Firefox
brew "mas"                   # Mac App Store CLI (for App Store-only apps)

# ---- Build tools / media / networking ---------------------------------------
brew "make"                  # GNU make (newer than Apple's; not guaranteed on a fresh Mac)
brew "cmake"                 # C/C++ build-system generator
brew "ffmpeg"                # audio/video transcoding & processing
brew "tree"                  # recursive directory listing
brew "socat"                 # multipurpose socket relay (TCP/UDP/UNIX)
brew "websocat"              # WebSocket client/server CLI (curl for ws://)

# ---- Terminal / editor / launcher ------------------------------------------
cask "ghostty"               # terminal
cask "zed"                   # editor
cask "visual-studio-code"    # editor (configured to mirror Zed: theme, Sublime keymap, Biome)
cask "raycast"               # launcher (covers clipboard, window-snap, caffeinate too)

# ---- Window management + keyboard -------------------------------------------
cask "nikitabobko/tap/aerospace"  # i3-style tiling WM, no SIP changes
cask "karabiner-elements"         # keyboard remapping (home-row mods, hyper key)
cask "homerow"                    # keyboard-driven clicking — "Vimium for all of macOS"
cask "jordanbaird-ice"            # menu-bar manager (free Bartender alternative)

# ---- Keep awake -------------------------------------------------------------
# Nothing to install: macOS ships the built-in `caffeinate` CLI (e.g.
# `caffeinate -d` to keep the display awake), and Raycast has a Keep-Awake
# command on top of it. No KeepingYouAwake / Amphetamine needed.

# ---- Containers / infra / web -----------------------------------------------
cask "orbstack"              # Docker Desktop replacement — far lighter & faster
cask "proxyman"              # HTTP(S) debugging proxy
cask "tableplus"             # database GUI

# ---- Browser ----------------------------------------------------------------
cask "google-chrome"
# (Heads up, not a nudge: Chrome means uBlock Origin *Lite* only. Full uBO lives
#  on Firefox/Brave — but you asked for Chrome, so Chrome it is.)

# ---- Tools / clients --------------------------------------------------------
cask "bruno"                 # local-first, git-friendly API client (Postman replacement)
cask "bitwarden"             # password manager
brew "bitwarden-cli"         # bw CLI + SSH agent

# ---- Fonts ------------------------------------------------------------------
cask "font-fira-code"        # plain Fira Code (ligatures, no patched glyph icons)

# =============================================================================
# App Store apps (requires being signed into the App Store — run `mas account`).
# Bear (notes) is App Store-only; there is no Homebrew cask for the notes app
# (the `bear` formula is an unrelated C/C++ build tool, so don't use that).
mas "Bear", id: 1091189122
# =============================================================================
