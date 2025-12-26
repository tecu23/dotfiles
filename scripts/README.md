# Dotfiles Scripts

This directory contains maintenance and testing scripts for the dotfiles setup.

## Scripts

### doctor.sh

**Purpose:** Run a comprehensive health check of your dotfiles installation.

**Usage:**
```bash
./scripts/doctor.sh
```

**What it checks:**
- Homebrew installation and package status
- mise tool manager and installed tools
- Git configuration and submodules
- Shell configuration (zsh, Oh My Zsh, themes)
- Application configurations (Neovim, tmux, Ghostty)
- Development tools availability
- Symlink integrity
- File permissions

**Exit codes:**
- `0` - All checks passed or warnings only
- `1` - Critical failures detected

**When to run:**
- After installing/updating dotfiles
- When troubleshooting issues
- Before making major changes
- Periodically to ensure everything is working

---

### update.sh

**Purpose:** Update all components of your dotfiles setup.

**Usage:**
```bash
./scripts/update.sh
```

**What it updates:**
- Git submodules (nvim, tmux plugins)
- Homebrew and all packages
- Homebrew casks
- mise (via Homebrew or self-update)
- mise-managed tools
- Checks for dotfiles repo updates

**Features:**
- Interactive confirmation before running
- Colored output for easy reading
- Shows what changed after updates
- Provides cleanup recommendations

**Note:** The script will prompt for confirmation before making changes.

---

### test-install.sh

**Purpose:** Preview what the install script would do without making changes.

**Usage:**
```bash
./scripts/test-install.sh
```

**What it shows:**
- Current status of dependencies (Homebrew, mise)
- Packages that would be installed from Brewfile
- Files that would be symlinked
- Potential conflicts with existing files
- Current tool versions

**When to use:**
- Before running the main install script
- To verify your system state
- To check for conflicts
- To understand what the installer does

---

## Workflow Examples

### Initial Setup
```bash
# 1. Preview the installation
./scripts/test-install.sh

# 2. Run the actual installation
cd ~/dotfiles && ./install.sh

# 3. Verify everything is working
./scripts/doctor.sh
```

### Regular Maintenance
```bash
# 1. Update everything
./scripts/update.sh

# 2. Verify health
./scripts/doctor.sh
```

### Troubleshooting
```bash
# Run the health check to identify issues
./scripts/doctor.sh

# Follow the recommendations in the output
# Re-run doctor.sh to confirm fixes
```

## Tips

- Run `doctor.sh` regularly to catch issues early
- Review the output of `update.sh` to see what changed
- Use `test-install.sh` before major changes to your dotfiles
- All scripts use colored output for better readability

## Requirements

All scripts require:
- Bash shell
- Access to the dotfiles directory
- Basic Unix utilities (readlink, command, etc.)

Individual scripts may require additional tools, which they will check for and report if missing.
