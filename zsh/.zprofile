# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Load private/local settings (not tracked in git)
# Create ~/dotfiles/zsh/private.zsh for machine-specific config
# Example: export GOPRIVATE=github.com/your-org
[ -f "$HOME/dotfiles/zsh/private.zsh" ] && source "$HOME/dotfiles/zsh/private.zsh"
