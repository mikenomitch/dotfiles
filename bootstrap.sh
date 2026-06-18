#!/usr/bin/env bash
# ~/dotfiles/bootstrap.sh — first-time setup on a fresh Mac.
#
# `make` isn't guaranteed on a clean macOS (it ships with the Xcode Command Line
# Tools), and we depend on mise anyway — so all the automation lives in mise
# tasks (see mise.toml). This script only does the pre-mise bootstrap that mise
# can't do for itself: install Homebrew + the Brewfile (which installs mise),
# then hand off to `mise run` for the rest.
set -euo pipefail
cd "$(dirname "$0")"

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Preflight: App Store (mas) sign-in, so the Bear install doesn't half-fail.
if grep -q '^mas ' Brewfile; then
  command -v mas >/dev/null 2>&1 || brew install mas
  if ! mas account >/dev/null 2>&1; then
    echo "✋ Brewfile has App Store (mas) apps but you're not signed in."
    echo "   Open the App Store app and sign in, then re-run. (Check: mas account)"
    exit 1
  fi
fi

# 3. Everything in the Brewfile (installs mise, stow, fish, …)
brew bundle --file=./Brewfile

# 4. Hand off to mise tasks (trust this repo's mise.toml first).
mise trust >/dev/null 2>&1 || true
mise install          # language runtimes from mise config
mise run link         # stow configs into $HOME
mise run macos        # system preferences

echo ""
echo "✅ Core setup done."
echo "Next (one-time, needs sudo):  mise run shell    (fish as default shell)"
echo "                              mise run touchid  (Touch ID for sudo)"
echo "Optional:                     mise run mcp  ·  mise run vscode"
