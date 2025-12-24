# dotfiles

Personal configuration files and settings for development environment.

## Structure

```
dotfiles/
├── README.md
├── .gitignore       # Gitignore for dotfiles repo
├── .gitmodules      # Git submodule configuration
├── install.sh       # Installation script
├── ghostty/
│   └── config       # Ghostty terminal configuration
├── git/
│   ├── .gitconfig   # Git user configuration
│   └── ignore       # Global gitignore
├── nvim/            # Neovim config (git submodule)
│   └── init.lua
├── tmux/            # Tmux config (git submodule)
│   └── tmux.conf
└── zsh/
    ├── .zprofile    # Zsh profile (loaded before .zshrc)
    ├── .zshrc       # Zsh configuration
    └── themes/
        └── pi.zsh-theme  # Custom Oh My Zsh theme
```

## Setup

1. Clone this repository (with submodules):

```bash
git clone --recurse-submodules git@github.com:tecu23/dotfiles-new.git ~/dotfiles
cd ~/dotfiles
```

If you already cloned without submodules, initialize them:

```bash
git submodule update --init --recursive
```

2. Run the installation script:

```bash
./install.sh
```

The script will:

- Backup any existing configuration files (with timestamp)
- Create symlinks from your home directory to the dotfiles repo
- Preserve your existing configs as `.backup.YYYYMMDD_HHMMSS`

3. Reload your shell:

```bash
source ~/.zshrc
```

## Configuration Details

### Git Configuration

**`.gitconfig`** - Git user settings:

- User name and email (uses GitHub private email)
- HTTPS to SSH URL rewrite for GitHub repositories
- Prevents exposing your personal email in commits

**`ignore`** (global gitignore):

- macOS files (`.DS_Store`)
- Linux/Windows system files
- Editor temporary files (`.swp`, `.swo`, etc.)
- IDE directories (`.vscode`, `.idea`)
- Log files
- Claude settings

All git commits will use your GitHub private email (`74561515+tecu23@users.noreply.github.com`) to maintain privacy.

### Zsh Configuration

The zsh setup includes two files:

**`.zprofile`** - Environment setup (loaded first):

- NVM (Node Version Manager) initialization
- Homebrew environment setup
- Additional PATH configurations
- Go private repository settings

**`.zshrc`** - Shell configuration (loaded after .zprofile):

- Oh My Zsh configuration
- Shell plugins
- Aliases and functions
- Theme settings

**Custom Oh My Zsh Theme (pi.zsh-theme)**:

- Minimal, clean prompt design
- Shows π symbol (green for success, red for failure)
- Smart path display (shortens when inside git repos)
- Git branch and status indicators
- Based on work by [@shashankmehta](https://github.com/shashankmehta)

The theme is automatically installed to `~/.oh-my-zsh/custom/themes/` if Oh My Zsh is present.

### Private/Machine-Specific Settings

For machine-specific or private configuration (API keys, work settings, etc.), create a `private.zsh` file:

```bash
# Create the file
touch ~/dotfiles/zsh/private.zsh

# Add your private settings
echo 'export GOPRIVATE=github.com/your-org' >> ~/dotfiles/zsh/private.zsh
```

This file is automatically:

- ✅ Sourced by `.zprofile` if it exists
- ✅ Ignored by git (listed in `.gitignore`)
- ✅ Never committed to the repository

**Example `private.zsh` contents:**

```bash
# Private/local configuration
export GOPRIVATE=github.com/algolia
export SOME_API_KEY=your_key_here
# Add any other machine-specific settings
```

## Usage

### Editing Configurations

Edit files in either location - changes apply to both:

```bash
# Edit via symlink
vim ~/.zshrc

# Or edit directly in repo
vim ~/dotfiles/zsh/.zshrc
```

### Committing Changes

```bash
cd ~/dotfiles
git add .
git commit -m "Update zsh configuration"
git push
```

### Deploying to a New Machine

```bash
git clone --recurse-submodules git@github.com:tecu23/dotfiles-new.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Working with Submodules (Neovim & Tmux)

Both neovim and tmux configurations are managed as git submodules, which means they are separate repositories.

**Note:** These submodules are configured to track the `main` branch, so they will automatically pull the latest changes when updated.

### Updating Submodule Configs

```bash
# Edit your config (changes are in the submodule)
nvim ~/.config/nvim/init.lua
# or
nvim ~/.config/tmux/tmux.conf

# Commit changes in the submodule
cd ~/dotfiles/nvim  # or ~/dotfiles/tmux
git add .
git commit -m "Update config"
git push

# Update the dotfiles repo to track the new submodule commit
cd ~/dotfiles
git add nvim  # or git add tmux
git commit -m "Update nvim submodule"  # or "Update tmux submodule"
git push
```

### Pulling Latest Changes from Main

To get the latest configs from the `main` branch:

```bash
cd ~/dotfiles
git pull
git submodule update --remote --merge  # Pulls latest from main branch for all submodules
```

This will:

1. Pull latest dotfiles changes
2. Update all submodules (nvim, tmux) to latest commit on `main`
3. Update the commit references in dotfiles repo

After updating, commit the new submodule references:

```bash
git add nvim tmux
git commit -m "Update submodules to latest main"
git push
```

## Adding More Configurations

To add new dotfiles:

1. Create a directory (e.g., `git/`, `vim/`, etc.)
2. Copy your config into it
3. Update `install.sh` to symlink the new file
4. Run `./install.sh` to create the symlink

To add a new submodule:

1. `git submodule add <repo-url> <directory-name>`
2. Update `install.sh` to symlink the directory
3. Commit `.gitmodules` and the new submodule
