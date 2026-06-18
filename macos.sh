#!/usr/bin/env bash
# ~/dotfiles/macos.sh  —  one-shot macOS system preferences. Run with: mise run macos
#
# Idempotent: every line is a `defaults write` (or similar) that just re-asserts a
# value, so running it again is harmless. Some changes need a logout/restart or an
# app relaunch to show up — we restart Finder/Dock/SystemUIServer at the end.
#
# Inspect any current value before changing it with:  defaults read <domain> <key>
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
  echo "macos.sh: not macOS — skipping." >&2
  exit 0
fi

echo "Applying macOS defaults… (you may be asked for your password)"

# Close System Settings so it doesn't overwrite values we're about to change.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# ---- Keyboard ---------------------------------------------------------------
# Fast key repeat — essential for vim-style hjkl movement. KeyRepeat is the
# repeat rate (lower = faster); InitialKeyRepeat is the delay before repeat.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable press-and-hold accent popover so holding a key actually repeats it.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Disable "smart" quotes/dashes and auto-capitalisation (they mangle code/prose).
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# ---- Trackpad ---------------------------------------------------------------
# Tap-to-click OFF: a light tap does nothing; you must physically click.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 0
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 0

# Traditional ("old default") scroll direction: content moves the same way as your
# fingers' wheel motion, i.e. the inverse of macOS's "natural" default.
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# ---- Finder -----------------------------------------------------------------
defaults write NSGlobalDomain AppleShowAllExtensions -bool true   # show all file extensions
defaults write com.apple.finder ShowPathbar -bool true            # path bar at the bottom
defaults write com.apple.finder ShowStatusBar -bool true          # status bar
defaults write com.apple.finder _FXSortFoldersFirst -bool true    # folders on top when sorting by name
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # search the current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # no nag on changing an extension
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true  # full POSIX path in the title bar
# Avoid creating .DS_Store on network and USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ---- Screenshots ------------------------------------------------------------
# Save to ~/Screenshots (created if missing) as PNG, without the drop shadow.
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ---- Dock -------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true              # auto-hide the Dock
defaults write com.apple.dock autohide-delay -float 0          # no delay before it appears
defaults write com.apple.dock autohide-time-modifier -float 0.15  # faster show/hide animation
defaults write com.apple.dock show-recents -bool false         # don't show recent apps
defaults write com.apple.dock mru-spaces -bool false           # don't auto-rearrange Spaces

# ---- Appearance -------------------------------------------------------------
# Dark mode. The `defaults` write makes it reproducible (and covers the login
# experience); the osascript applies it live to the running session too.
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null || true

# ---- Misc -------------------------------------------------------------------
# Expand the Save and Print panels by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# Save to disk (not iCloud) by default.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# ---- Apply ------------------------------------------------------------------
for app in Finder Dock SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done

echo "✅ macOS defaults applied. Some changes need a logout/restart to fully take effect."
