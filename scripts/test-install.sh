#!/bin/bash
# Test the install script in a safe way
# This creates a test environment and shows what would happen

set -e

echo "=== Dotfiles Install Script Test ==="
echo ""
echo "This will show you what the install script would do without actually doing it."
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

# Check Homebrew
echo "Checking Homebrew..."
if command -v brew &> /dev/null; then
    echo "✅ Homebrew is installed: $(brew --version | head -1)"
else
    echo "❌ Homebrew is NOT installed"
fi
echo ""

# Check Brewfile packages
echo "Checking Brewfile packages..."
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo "📦 Would install these packages from Brewfile:"
    grep "^brew " "$DOTFILES_DIR/Brewfile" | sed 's/brew /  - /'
    echo ""
    grep "^cask " "$DOTFILES_DIR/Brewfile" | sed 's/cask /  - /'
else
    echo "❌ Brewfile not found"
fi
echo ""

# Check mise
echo "Checking mise..."
if command -v mise &> /dev/null; then
    echo "✅ mise is installed: $(mise --version)"
    echo "📋 Currently installed tools:"
    mise list
else
    echo "❌ mise is NOT installed"
fi
echo ""

# Check what would be symlinked
echo "Files that would be symlinked:"
echo "  ~/.gitconfig -> $DOTFILES_DIR/git/.gitconfig"
echo "  ~/.config/git/ignore -> $DOTFILES_DIR/git/ignore"
echo "  ~/.zshrc -> $DOTFILES_DIR/zsh/.zshrc"
echo "  ~/.zprofile -> $DOTFILES_DIR/zsh/.zprofile"
echo "  ~/.config/nvim -> $DOTFILES_DIR/nvim"
echo "  ~/.config/tmux -> $DOTFILES_DIR/tmux"
echo "  ~/.config/ghostty -> $DOTFILES_DIR/ghostty"
echo "  ~/.config/mise/config.toml -> $DOTFILES_DIR/mise/config.toml"
echo ""

# Check for conflicts
echo "Checking for conflicts..."
conflicts=0
for file in ~/.gitconfig ~/.zshrc ~/.zprofile; do
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        echo "⚠️  $file exists (would be backed up)"
        conflicts=1
    fi
done

if [ $conflicts -eq 0 ]; then
    echo "✅ No conflicts found"
fi
echo ""

echo "=== Test Complete ==="
echo ""
echo "To actually run the install, use:"
echo "  cd $DOTFILES_DIR && ./install.sh"
