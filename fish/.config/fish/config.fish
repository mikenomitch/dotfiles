# ~/.config/fish/config.fish
# Minimal, fast. Fish already ships autosuggestions, syntax highlighting and
# good completions, so there is almost nothing to configure.

# Don't print the greeting on new shells
set -g fish_greeting

# --- PATH ---
fish_add_path $HOME/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

if status is-interactive
    # --- Tool init (order matters: mise sets up PATH for shims) ---
    mise activate fish | source
    starship init fish | source
    zoxide init fish | source

    # fzf key bindings + completions (Ctrl-R history, Ctrl-T files, Alt-C cd)
    fzf --fish | source

    # --- Abbreviations (expand inline, so you learn the real command) ---
    abbr -a gs   git status
    abbr -a gd   git diff
    abbr -a gco  git checkout
    abbr -a gp   git push
    abbr -a gpl  git pull
    abbr -a gl   git log
    abbr -a lg   "git log --oneline --graph --decorate"

    abbr -a pn   pnpm
    abbr -a pnx  pnpm dlx
    abbr -a pi   pnpm install
    abbr -a pd   pnpm dev

    abbr -a wr   wrangler
    abbr -a cc   claude          # Claude Code

    # --- Aliases for the modern CLI tools ---
    alias ls   "eza --group-directories-first"
    alias ll   "eza -la --group-directories-first --git"
    alias lt   "eza --tree --level=2"
    alias find "fd"
    alias grep "rg"
    alias top  "btop"
    alias du   "dust"
    alias cd   "z"               # zoxide takes over cd
end
