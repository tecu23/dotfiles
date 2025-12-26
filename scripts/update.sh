#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Dotfiles Update Script            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Function to print section headers
print_section() {
    echo ""
    echo -e "${BLUE}▶ $1${NC}"
    echo "────────────────────────────────────────"
}

# Function to handle errors
handle_error() {
    echo -e "${RED}✗ Error: $1${NC}"
    return 1
}

# Confirm with user
echo -e "${YELLOW}This script will update:${NC}"
echo "  • Git submodules (nvim, tmux)"
echo "  • Homebrew and all packages"
echo "  • Mise and all tools"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Update cancelled."
    exit 0
fi

# Update git submodules
print_section "Updating Git Submodules"
cd "$DOTFILES_DIR"
if git submodule update --remote --merge; then
    echo -e "${GREEN}✓ Submodules updated${NC}"

    # Show what changed
    if git diff --quiet HEAD; then
        echo "  No submodule changes"
    else
        echo -e "${YELLOW}  Submodule changes detected:${NC}"
        git submodule foreach 'echo "  - $(basename $path): $(git log -1 --format=%s)"'
    fi
else
    handle_error "Failed to update submodules"
fi

# Update Homebrew
print_section "Updating Homebrew"
if command -v brew &> /dev/null; then
    if brew update; then
        echo -e "${GREEN}✓ Homebrew updated${NC}"
    else
        handle_error "Failed to update Homebrew"
    fi

    # Upgrade packages
    print_section "Upgrading Homebrew Packages"
    if brew upgrade; then
        echo -e "${GREEN}✓ Packages upgraded${NC}"
    else
        echo -e "${YELLOW}⚠ Some packages may have failed to upgrade${NC}"
    fi

    # Install any new packages from Brewfile
    print_section "Installing Packages from Brewfile"
    cd "$DOTFILES_DIR"
    if brew bundle; then
        echo -e "${GREEN}✓ Brewfile packages synced${NC}"
    else
        handle_error "Failed to install Brewfile packages"
    fi

    # Cleanup
    print_section "Cleaning up Homebrew"
    if brew cleanup; then
        echo -e "${GREEN}✓ Homebrew cleanup complete${NC}"
    else
        echo -e "${YELLOW}⚠ Cleanup had issues${NC}"
    fi

    # Check for outdated casks
    echo ""
    echo -e "${YELLOW}Checking for outdated casks...${NC}"
    outdated_casks=$(brew outdated --cask)
    if [ -z "$outdated_casks" ]; then
        echo -e "${GREEN}✓ All casks are up to date${NC}"
    else
        echo -e "${YELLOW}Outdated casks (may require manual update):${NC}"
        echo "$outdated_casks"
    fi
else
    echo -e "${YELLOW}⚠ Homebrew not found, skipping package updates${NC}"
fi

# Update mise
print_section "Updating mise"
if command -v mise &> /dev/null; then
    # Check if mise was installed via package manager
    if brew list mise &> /dev/null; then
        print_section "Updating mise via Homebrew"
        if brew upgrade mise; then
            echo -e "${GREEN}✓ mise updated via Homebrew${NC}"
        else
            echo -e "${YELLOW}⚠ mise may already be at latest version${NC}"
        fi
    else
        # Try self-update for standalone installations
        if mise self-update 2>&1 | grep -q "cannot update"; then
            echo -e "${YELLOW}⚠ mise is installed via a package manager${NC}"
            echo "  Use your package manager to update mise"
        else
            echo -e "${GREEN}✓ mise self-updated${NC}"
        fi
    fi

    # Upgrade mise tools
    print_section "Upgrading mise Tools"
    if mise upgrade; then
        echo -e "${GREEN}✓ mise tools upgraded${NC}"
    else
        echo -e "${YELLOW}⚠ Some mise tools may have failed to upgrade${NC}"
    fi

    # Show current versions
    echo ""
    echo -e "${YELLOW}Current mise tool versions:${NC}"
    mise list
else
    echo -e "${YELLOW}⚠ mise not found, skipping tool updates${NC}"
fi

# Check for dotfiles repo updates
print_section "Checking for Dotfiles Updates"
cd "$DOTFILES_DIR"
git fetch origin

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u} 2>/dev/null || echo "")
BASE=$(git merge-base @ @{u} 2>/dev/null || echo "")

if [ -z "$REMOTE" ]; then
    echo -e "${YELLOW}⚠ No upstream branch configured${NC}"
elif [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}✓ Dotfiles repo is up to date${NC}"
elif [ "$LOCAL" = "$BASE" ]; then
    echo -e "${YELLOW}⚠ Your dotfiles repo is behind origin${NC}"
    echo "  Run 'git pull' in $DOTFILES_DIR to update"
elif [ "$REMOTE" = "$BASE" ]; then
    echo -e "${YELLOW}⚠ Your dotfiles repo has unpushed commits${NC}"
else
    echo -e "${YELLOW}⚠ Your dotfiles repo has diverged from origin${NC}"
fi

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Update Complete!                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ All updates complete${NC}"
echo ""
echo -e "${YELLOW}Note:${NC} You may need to restart your terminal or run:"
echo "  source ~/.zshrc"
echo ""
echo -e "${BLUE}Tip:${NC} Run the health check to verify everything:"
echo "  $DOTFILES_DIR/scripts/doctor.sh"
echo ""
