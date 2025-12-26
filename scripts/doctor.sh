#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Counters for summary
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Dotfiles Health Check             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Checking dotfiles installation at: $DOTFILES_DIR"
echo ""

# Function to print section headers
print_section() {
    echo ""
    echo -e "${BLUE}▶ $1${NC}"
    echo "────────────────────────────────────────"
}

# Function to print check results
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((CHECKS_PASSED++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((CHECKS_FAILED++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((CHECKS_WARNING++))
}

# Check Homebrew
print_section "Homebrew"

if command -v brew &> /dev/null; then
    check_pass "Homebrew is installed: $(brew --version | head -1)"

    # Check if Homebrew is in PATH
    if [[ ":$PATH:" == *":/opt/homebrew/bin:"* ]] || [[ ":$PATH:" == *":/usr/local/bin:"* ]]; then
        check_pass "Homebrew is in PATH"
    else
        check_warn "Homebrew may not be properly configured in PATH"
    fi

    # Check for Brewfile
    if [ -f "$DOTFILES_DIR/Brewfile" ]; then
        check_pass "Brewfile exists"

        # Check if all Brewfile packages are installed
        echo "  Checking Brewfile packages..."
        if timeout 5 brew bundle check --file="$DOTFILES_DIR/Brewfile" --no-upgrade &> /dev/null; then
            check_pass "All Brewfile packages are installed"
        else
            check_warn "Some Brewfile packages may be missing or check timed out"
            echo "  Run: cd $DOTFILES_DIR && brew bundle install"
        fi
    else
        check_fail "Brewfile not found"
    fi

    # Check for outdated packages
    outdated_count=$(brew outdated --quiet | wc -l | tr -d ' ')
    if [ "$outdated_count" -eq 0 ]; then
        check_pass "All Homebrew packages are up to date"
    else
        check_warn "$outdated_count Homebrew package(s) are outdated"
        echo "  Run: brew upgrade"
    fi
else
    check_fail "Homebrew is not installed"
    echo "  Install with: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
fi

# Check mise
print_section "mise (Tool Version Manager)"

if command -v mise &> /dev/null; then
    check_pass "mise is installed: $(mise --version)"

    # Check if mise config exists
    if [ -f "$HOME/.config/mise/config.toml" ]; then
        check_pass "mise config exists at ~/.config/mise/config.toml"

        # Check if it's a symlink to dotfiles
        if [ -L "$HOME/.config/mise/config.toml" ]; then
            target=$(readlink "$HOME/.config/mise/config.toml")
            if [ "$target" = "$DOTFILES_DIR/mise/config.toml" ]; then
                check_pass "mise config is correctly symlinked"
            else
                check_warn "mise config is symlinked but not to dotfiles"
            fi
        else
            check_warn "mise config exists but is not a symlink"
        fi
    else
        check_fail "mise config not found at ~/.config/mise/config.toml"
    fi

    # Check if mise is activated
    if type mise &> /dev/null && declare -f mise &> /dev/null; then
        check_pass "mise is activated in current shell"
    else
        check_warn "mise may not be activated (run: source ~/.zshrc)"
    fi

    # Check installed tools
    echo "  Checking mise tools..."
    mise_tools=$(mise list 2>/dev/null | wc -l | tr -d ' ')
    if [ "$mise_tools" -gt 0 ]; then
        check_pass "$mise_tools tool(s) installed via mise"
        echo "  Current tools:"
        mise list | sed 's/^/    /'
    else
        check_warn "No tools installed via mise"
        echo "  Expected tools: jq, node, ruby, go, terraform, gcloud, python, java"
    fi

    # Check for outdated mise tools
    if mise outdated &> /dev/null; then
        outdated_mise=$(mise outdated 2>/dev/null | grep -v "^$" | wc -l | tr -d ' ')
        if [ "$outdated_mise" -eq 0 ]; then
            check_pass "All mise tools are up to date"
        else
            check_warn "$outdated_mise mise tool(s) are outdated"
            echo "  Run: mise upgrade"
        fi
    fi
else
    check_fail "mise is not installed"
    echo "  Install with: brew install mise"
fi

# Check Git Configuration
print_section "Git Configuration"

if command -v git &> /dev/null; then
    check_pass "Git is installed: $(git --version)"

    # Check gitconfig
    if [ -L "$HOME/.gitconfig" ]; then
        target=$(readlink "$HOME/.gitconfig")
        if [ "$target" = "$DOTFILES_DIR/git/.gitconfig" ]; then
            check_pass "~/.gitconfig is correctly symlinked"
        else
            check_warn "~/.gitconfig is symlinked but not to dotfiles"
        fi
    elif [ -f "$HOME/.gitconfig" ]; then
        check_warn "~/.gitconfig exists but is not a symlink"
    else
        check_fail "~/.gitconfig not found"
    fi

    # Check git ignore
    if [ -L "$HOME/.config/git/ignore" ]; then
        target=$(readlink "$HOME/.config/git/ignore")
        if [ "$target" = "$DOTFILES_DIR/git/ignore" ]; then
            check_pass "~/.config/git/ignore is correctly symlinked"
        else
            check_warn "~/.config/git/ignore is symlinked but not to dotfiles"
        fi
    elif [ -f "$HOME/.config/git/ignore" ]; then
        check_warn "~/.config/git/ignore exists but is not a symlink"
    else
        check_fail "~/.config/git/ignore not found"
    fi

    # Check git submodules
    cd "$DOTFILES_DIR"
    if [ -f ".gitmodules" ]; then
        check_pass "Git submodules configuration exists"

        # Check if submodules are initialized
        if git submodule status | grep -q "^-"; then
            check_fail "Some git submodules are not initialized"
            echo "  Run: git submodule update --init --recursive"
        else
            check_pass "All git submodules are initialized"
        fi
    fi
else
    check_fail "Git is not installed"
fi

# Check Shell Configuration
print_section "Shell Configuration"

# Check default shell
if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/local/bin/zsh" ] || [ "$SHELL" = "/opt/homebrew/bin/zsh" ]; then
    check_pass "Default shell is zsh"
else
    check_warn "Default shell is not zsh: $SHELL"
    echo "  Change with: chsh -s /bin/zsh"
fi

# Check zshrc
if [ -L "$HOME/.zshrc" ]; then
    target=$(readlink "$HOME/.zshrc")
    if [ "$target" = "$DOTFILES_DIR/zsh/.zshrc" ]; then
        check_pass "~/.zshrc is correctly symlinked"
    else
        check_warn "~/.zshrc is symlinked but not to dotfiles"
    fi
elif [ -f "$HOME/.zshrc" ]; then
    check_warn "~/.zshrc exists but is not a symlink"
else
    check_fail "~/.zshrc not found"
fi

# Check zprofile
if [ -L "$HOME/.zprofile" ]; then
    target=$(readlink "$HOME/.zprofile")
    if [ "$target" = "$DOTFILES_DIR/zsh/.zprofile" ]; then
        check_pass "~/.zprofile is correctly symlinked"
    else
        check_warn "~/.zprofile is symlinked but not to dotfiles"
    fi
elif [ -f "$HOME/.zprofile" ]; then
    check_warn "~/.zprofile exists but is not a symlink"
else
    check_fail "~/.zprofile not found"
fi

# Check Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    check_pass "Oh My Zsh is installed"

    # Check custom theme
    if [ -L "$HOME/.oh-my-zsh/custom/themes/pi.zsh-theme" ]; then
        check_pass "Custom zsh theme is symlinked"
    else
        check_warn "Custom zsh theme not found or not symlinked"
    fi
else
    check_warn "Oh My Zsh is not installed"
fi

# Check Neovim
print_section "Neovim"

if command -v nvim &> /dev/null; then
    check_pass "Neovim is installed: $(nvim --version | head -1)"

    # Check nvim config
    if [ -L "$HOME/.config/nvim" ]; then
        target=$(readlink "$HOME/.config/nvim")
        if [ "$target" = "$DOTFILES_DIR/nvim" ]; then
            check_pass "~/.config/nvim is correctly symlinked"
        else
            check_warn "~/.config/nvim is symlinked but not to dotfiles"
        fi
    elif [ -d "$HOME/.config/nvim" ]; then
        check_warn "~/.config/nvim exists but is not a symlink"
    else
        check_fail "~/.config/nvim not found"
    fi

    # Check if lazy.nvim is installed
    if [ -d "$HOME/.local/share/nvim/lazy" ]; then
        check_pass "Lazy.nvim plugin manager is installed"
    else
        check_warn "Lazy.nvim not found (will be installed on first nvim run)"
    fi
else
    check_fail "Neovim is not installed"
    echo "  Install with: brew install neovim"
fi

# Check tmux
print_section "tmux"

if command -v tmux &> /dev/null; then
    check_pass "tmux is installed: $(tmux -V)"

    # Check tmux config
    if [ -L "$HOME/.config/tmux" ]; then
        target=$(readlink "$HOME/.config/tmux")
        if [ "$target" = "$DOTFILES_DIR/tmux" ]; then
            check_pass "~/.config/tmux is correctly symlinked"
        else
            check_warn "~/.config/tmux is symlinked but not to dotfiles"
        fi
    elif [ -d "$HOME/.config/tmux" ]; then
        check_warn "~/.config/tmux exists but is not a symlink"
    else
        check_fail "~/.config/tmux not found"
    fi
else
    check_fail "tmux is not installed"
    echo "  Install with: brew install tmux"
fi

# Check Ghostty
print_section "Ghostty Terminal"

if command -v ghostty &> /dev/null || [ -d "/Applications/Ghostty.app" ]; then
    check_pass "Ghostty is installed"

    # Check ghostty config
    if [ -L "$HOME/.config/ghostty" ]; then
        target=$(readlink "$HOME/.config/ghostty")
        if [ "$target" = "$DOTFILES_DIR/ghostty" ]; then
            check_pass "~/.config/ghostty is correctly symlinked"
        else
            check_warn "~/.config/ghostty is symlinked but not to dotfiles"
        fi
    elif [ -d "$HOME/.config/ghostty" ]; then
        check_warn "~/.config/ghostty exists but is not a symlink"
    else
        check_fail "~/.config/ghostty not found"
    fi
else
    check_warn "Ghostty is not installed"
    echo "  Install with: brew install --cask ghostty"
fi

# Check Development Tools
print_section "Development Tools"

# Key tools from Brewfile
tools_to_check=("gh" "fzf" "rg" "fd" "bat" "jq" "kubectl" "k9s")
for tool in "${tools_to_check[@]}"; do
    if command -v "$tool" &> /dev/null; then
        check_pass "$tool is installed"
    else
        check_warn "$tool is not installed"
    fi
done

# Check Docker
if command -v docker &> /dev/null; then
    check_pass "Docker is installed"
    if timeout 3 docker info &> /dev/null; then
        check_pass "Docker daemon is running"
    else
        check_warn "Docker daemon is not running or not responding"
        echo "  Start Docker Desktop or run: open -a Docker"
    fi
else
    check_warn "Docker is not installed"
fi

# Check Permissions
print_section "Permissions"

# Check if we can write to config directories
if [ -w "$HOME/.config" ]; then
    check_pass "Can write to ~/.config"
else
    check_fail "Cannot write to ~/.config"
fi

if [ -w "$DOTFILES_DIR" ]; then
    check_pass "Can write to dotfiles directory"
else
    check_warn "Cannot write to dotfiles directory"
fi

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Health Check Summary              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

total_checks=$((CHECKS_PASSED + CHECKS_FAILED + CHECKS_WARNING))
echo "Total checks: $total_checks"
echo -e "${GREEN}Passed: $CHECKS_PASSED${NC}"
echo -e "${YELLOW}Warnings: $CHECKS_WARNING${NC}"
echo -e "${RED}Failed: $CHECKS_FAILED${NC}"
echo ""

if [ $CHECKS_FAILED -eq 0 ] && [ $CHECKS_WARNING -eq 0 ]; then
    echo -e "${GREEN}🎉 Everything looks great!${NC}"
    exit 0
elif [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${YELLOW}✓ System is healthy with some warnings${NC}"
    echo ""
    echo "Recommendations:"
    echo "  - Review warnings above"
    echo "  - Run: $DOTFILES_DIR/scripts/update.sh"
    exit 0
else
    echo -e "${RED}⚠ Some issues need attention${NC}"
    echo ""
    echo "Recommended actions:"
    echo "  1. Fix critical failures (marked with ✗)"
    echo "  2. Run: cd $DOTFILES_DIR && ./install.sh"
    echo "  3. Run: source ~/.zprofile && source ~/.zshrc"
    echo "  4. Run this doctor script again"
    exit 1
fi
