# ~/dotfiles/Makefile  —  run targets from inside ~/dotfiles
# New machine:  git clone <repo> ~/dotfiles && cd ~/dotfiles && make bootstrap

SHELL := /bin/bash
STOW_PKGS := mise starship fish ghostty aerospace zed claude vscode git ssh
CODE := $(shell command -v code 2>/dev/null || echo "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code")
BREW := /opt/homebrew/bin/brew

.PHONY: bootstrap brew preflight link relink unlink ssh-dirs mise shell touchid macos mcp vscode update doctor

## Full first-time setup on a fresh Mac
bootstrap: brew link mise macos
	@echo ""
	@echo "✅ Core setup done."
	@echo "Next (one-time, needs sudo):  make shell   (fish as default shell)"
	@echo "                              make touchid (Touch ID for sudo)"
	@echo "Optional:                     make mcp"

## Fail early if the Brewfile needs the App Store but you're not signed in.
## (mas can't install Bear etc. unless `mas account` shows a signed-in Apple ID.)
preflight:
	@if grep -q '^mas ' Brewfile; then \
		command -v mas >/dev/null 2>&1 || $(BREW) install mas; \
		mas account >/dev/null 2>&1 || { \
			echo "✋ Brewfile has App Store (mas) apps but you're not signed in."; \
			echo "   Open the App Store app and sign in, then re-run. (Check: mas account)"; \
			exit 1; }; \
	fi

## Install Homebrew (if missing) + everything in the Brewfile
brew: preflight
	@command -v brew >/dev/null 2>&1 || \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	$(BREW) bundle --file=./Brewfile

## Ensure ~/.ssh is a real dir (perms 700) so stow links config into it instead
## of folding the whole directory into a symlink (which would put keys in the repo).
ssh-dirs:
	@mkdir -p $$HOME/.ssh/control && chmod 700 $$HOME/.ssh $$HOME/.ssh/control

## Symlink all config packages into $HOME
link: ssh-dirs
	stow --target=$$HOME --verbose $(STOW_PKGS)

## Re-link after adding/removing files (safe to run repeatedly)
relink: ssh-dirs
	stow --restow --target=$$HOME --verbose $(STOW_PKGS)

## Remove all symlinks this repo created
unlink:
	stow --delete --target=$$HOME --verbose $(STOW_PKGS)

## Install/refresh everything declared in mise config
mise:
	mise install
	mise reshim

## Make fish the default shell (needs sudo to edit /etc/shells)
shell:
	@grep -qxF "$(BREW:brew=fish)" /etc/shells || echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
	chsh -s /opt/homebrew/bin/fish

## Enable Touch ID for sudo via /etc/pam.d/sudo_local (survives OS updates,
## unlike editing /etc/pam.d/sudo directly). Needs sudo. Idempotent.
touchid:
	@if [ ! -f /etc/pam.d/sudo_local ] || ! grep -q 'pam_tid.so' /etc/pam.d/sudo_local; then \
		printf '# Written by ~/dotfiles (make touchid)\nauth       sufficient     pam_tid.so\n' \
			| sudo tee /etc/pam.d/sudo_local >/dev/null; \
		echo "✅ Touch ID for sudo enabled."; \
	else \
		echo "Touch ID for sudo already enabled."; \
	fi

## Apply macOS system preferences (key repeat, Finder, Dock, screenshots, …)
macos:
	bash ./macos.sh

## Register user-scope MCP servers for Claude Code (edit URLs to taste)
mcp:
	@echo "Registering user-scope MCP servers for Claude Code..."
	# GitHub (remote, OAuth):
	-claude mcp add --scope user --transport http github https://api.githubcopilot.com/mcp/
	# Cloudflare: install their official skills+MCP plugin instead of hand-adding URLs:
	#   npx skills add https://github.com/cloudflare/skills
	@echo "Run 'claude mcp list' to verify."

## Install VS Code extensions + the local Tomorrow Night Bright theme
vscode:
	@test -x "$(CODE)" || { echo "VS Code 'code' CLI not found. Open VS Code → Command Palette → 'Shell Command: Install code command in PATH', then rerun."; exit 1; }
	@grep -vE '^\s*#|^\s*$$' vscode-extensions.txt | while read -r ext; do "$(CODE)" --install-extension "$$ext" --force; done
	# Local theme: copy (not symlink — VS Code is finicky about symlinked extensions)
	mkdir -p "$$HOME/.vscode/extensions/mikenomitch.tomorrow-night-bright-1.0.0"
	cp -R vscode-theme/ "$$HOME/.vscode/extensions/mikenomitch.tomorrow-night-bright-1.0.0/"
	@echo "✅ VS Code extensions + theme installed. Reload VS Code."

## Pull latest, re-link, update packages
update:
	git pull --rebase
	$(BREW) bundle --file=./Brewfile
	mise upgrade
	$(MAKE) relink

## Sanity check: tools on PATH + symlink health (dry-run shows conflicts/breaks)
doctor:
	@echo "── tools ──────────────────────────────────────────"
	@echo "brew:     $$(command -v brew || echo MISSING)"
	@echo "mise:     $$(command -v mise || echo MISSING)"
	@echo "fish:     $$(command -v fish || echo MISSING)"
	@echo "starship: $$(command -v starship || echo MISSING)"
	@echo "stow:     $$(command -v stow || echo MISSING)"
	@echo "claude:   $$(command -v claude || echo MISSING)"
	@echo "uv:       $$(command -v uv || echo MISSING)"
	@echo "── symlinks (stow dry-run; no output below = all healthy) ──"
	@$(MAKE) -s ssh-dirs
	@stow --no --target=$$HOME --verbose=2 $(STOW_PKGS) 2>&1 \
		| grep -vE '^(LINK|stow dir|cwd|Planning|No differences)' || true
	@echo "── sudo ───────────────────────────────────────────"
	@grep -q 'pam_tid.so' /etc/pam.d/sudo_local 2>/dev/null \
		&& echo "Touch ID for sudo: enabled" || echo "Touch ID for sudo: NOT set (run: make touchid)"
