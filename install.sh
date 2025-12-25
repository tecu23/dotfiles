#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing dotfiles from ${DOTFILES_DIR}"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo ""
    echo "Homebrew not found. Installing Homebrew..."
    echo -e "${YELLOW}Note: Homebrew will be configured via your dotfiles (.zprofile)${NC}"

    # Install Homebrew in non-interactive mode to prevent it from modifying shell files
    # Our dotfiles already have the proper Homebrew configuration
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this installation session
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    echo -e "${GREEN}Homebrew installed successfully${NC}"
else
    echo ""
    echo -e "${GREEN}Homebrew is already installed${NC}"
fi

# Install packages from Brewfile
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo ""
    echo "Installing packages from Brewfile..."
    cd "$DOTFILES_DIR"
    brew bundle install
    echo -e "${GREEN}Brewfile packages installed${NC}"
else
    echo ""
    echo -e "${YELLOW}Brewfile not found, skipping package installation${NC}"
fi

# Function to backup existing file if it exists and is not a symlink
backup_if_exists() {
    if [ -e "$1" ] && [ ! -L "$1" ]; then
        backup_path="$1.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$1" "$backup_path"
        echo -e "${YELLOW}Backed up existing file: $1 -> $backup_path${NC}"
    fi
}

# Function to create symlink
link_file() {
    local source=$1
    local target=$2

    # Remove existing symlink if present
    if [ -L "$target" ]; then
        rm "$target"
        echo -e "${YELLOW}Removed existing symlink: $target${NC}"
    fi

    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}Linked: $target -> $source${NC}"
}

# Install git configuration
echo ""
echo "Installing git configuration..."
backup_if_exists "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

mkdir -p "$HOME/.config/git"
backup_if_exists "$HOME/.config/git/ignore"
link_file "$DOTFILES_DIR/git/ignore" "$HOME/.config/git/ignore"

# Install zsh configuration
echo ""
echo "Installing zsh configuration..."
backup_if_exists "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

backup_if_exists "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"

# Install Oh My Zsh custom theme
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo ""
    echo "Installing Oh My Zsh custom theme..."
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    backup_if_exists "$HOME/.oh-my-zsh/custom/themes/pi.zsh-theme"
    link_file "$DOTFILES_DIR/zsh/themes/pi.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/pi.zsh-theme"
else
    echo ""
    echo -e "${YELLOW}Skipping Oh My Zsh theme (Oh My Zsh not installed)${NC}"
fi

# Install neovim configuration
echo ""
echo "Installing neovim configuration..."
# Ensure .config directory exists
mkdir -p "$HOME/.config"
backup_if_exists "$HOME/.config/nvim"
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Install tmux configuration
echo ""
echo "Installing tmux configuration..."
backup_if_exists "$HOME/.config/tmux"
link_file "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"

# Install ghostty configuration
echo ""
echo "Installing ghostty configuration..."
backup_if_exists "$HOME/.config/ghostty"
link_file "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "To reload your shell configuration, run:"
echo "  source ~/.zshrc"
