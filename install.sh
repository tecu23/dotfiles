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

# Install zsh configuration
echo ""
echo "Installing zsh configuration..."
backup_if_exists "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

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
