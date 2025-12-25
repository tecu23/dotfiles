# dotfiles

Personal configuration files and settings for development environment.

## Structure

```
dotfiles/
├── README.md
├── .gitignore       # Gitignore for dotfiles repo
├── .gitmodules      # Git submodule configuration
├── Brewfile         # Homebrew packages (GCP, K8s, Terraform, etc.)
├── install.sh       # Installation script
├── ghostty/
│   └── config       # Ghostty terminal configuration
├── git/
│   ├── .gitconfig   # Git user configuration
│   └── ignore       # Global gitignore
├── mise/
│   └── config.toml  # mise version manager configuration
├── nvim/            # Neovim config (git submodule)
│   └── init.lua
├── scripts/
│   └── test-install.sh  # Test installation script
├── tmux/            # Tmux config (git submodule)
│   └── tmux.conf
└── zsh/
    ├── .zprofile    # Zsh profile (loaded before .zshrc)
    ├── .zshrc       # Zsh configuration
    ├── aliases.zsh  # Shell aliases (git, k8s, terraform, docker, gcp)
    ├── functions.zsh # Shell functions
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

- Homebrew environment setup
- Additional PATH configurations
- Go private repository settings

**`.zshrc`** - Shell configuration (loaded after .zprofile):

- Oh My Zsh configuration
- Shell plugins
- mise initialization (version management)
- Custom aliases and functions
- Theme settings

**`aliases.zsh`** - Productivity aliases for:

- Git (g, gs, ga, gc, gp, etc.)
- Kubernetes (k, kx, kns, kgp, etc.)
- Terraform (tf, tfi, tfp, tfa, etc.)
- Docker (d, dc, dps, etc.)
- GCP (gcl, gcp, gcsp)
- Modern CLI tools (bat, fd, rg)

**`functions.zsh`** - Useful shell functions:

- Kubernetes helpers (klog, kexec, kns)
- Git helpers (gcbp, gcp)
- GCP helpers (gcpswitch, gke-creds)
- Terraform helpers (tfplan, tfapply)
- Utilities (mkcd, extract, port)

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

## Version Management with mise

This repo uses [mise](https://mise.jdx.dev/) for unified version management of Node.js, Ruby, Go, Python, and other tools.

### Why mise?

- **One tool** instead of nvm, rbenv, pyenv, gvm, etc.
- **Unified commands** - same syntax for all languages
- **Reads legacy files** - `.nvmrc`, `.ruby-version`, etc. still work
- **Faster shell startup** - written in Rust, minimal overhead
- **500+ tools supported** - languages, CLIs, and more

### Common mise Commands

```bash
# List all installed tools
mise list

# List available versions
mise list-all node
mise list-all ruby

# Install specific versions
mise install node@20.11.0
mise install ruby@3.3.0

# Set global versions (across all projects)
mise use --global node@20
mise use --global ruby@3.3

# Set project-specific versions (creates .mise.toml)
cd my-project
mise use node@18 ruby@3.2

# Check for outdated tools
mise outdated

# Upgrade tools
mise upgrade
```

### Migration from nvm/rbenv

The `mise` branch has already migrated from nvm/rbenv. If you're on an existing system:

1. Your existing `.nvmrc` and `.ruby-version` files will still work (mise reads them)
2. Install tools: `mise install node@lts ruby@3.3`
3. Set global defaults: `mise use --global node@lts ruby@3.3`
4. Optional: Remove old version managers once comfortable

## Brewfile - Package Management

The `Brewfile` defines all Homebrew packages, casks, and extensions for your development environment:

### Categories

- **Development utilities**: bat, direnv, fzf, tree, watch
- **Cloud tools**: google-cloud-sdk, grpcurl
- **Kubernetes**: helm, kind, k9s, kubectx, skaffold, stern
- **Container tools**: docker-desktop, ctop, dive
- **Terraform**: terraform, tflint, tfsec, terraform-docs
- **Version management**: mise
- **And more...**

### Usage

```bash
# Install all packages
brew bundle install

# Check what's installed
brew bundle list

# Cleanup packages not in Brewfile
brew bundle cleanup

# Add new package
echo 'brew "package-name"' >> Brewfile
brew bundle install
```

## Testing Installation

### Test Without a Fresh Mac

You can test the installation script safely on your current Mac:

#### Option 1: Dry-run Test Script

```bash
./scripts/test-install.sh
```

This shows what would happen without making changes.

#### Option 2: Create a Test User

```bash
# Create a test user account
sudo dscl . -create /Users/testuser
sudo dscl . -create /Users/testuser UserShell /bin/zsh
sudo dscl . -create /Users/testuser RealName "Test User"
sudo dscl . -create /Users/testuser UniqueID 503
sudo dscl . -create /Users/testuser PrimaryGroupID 20
sudo dscl . -create /Users/testuser NFSHomeDirectory /Users/testuser
sudo dscl . -passwd /Users/testuser password123

# Create home directory
sudo createhomedir -c -u testuser

# Log out, log in as testuser, run install script
# Log back in as main user and delete when done:
sudo dscl . -delete /Users/testuser
sudo rm -rf /Users/testuser
```

#### Option 3: Selective Testing

Test individual components:

```bash
# Test Brewfile
brew bundle install --file=Brewfile --no-lock

# Test symlinks (see what would be linked)
ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim

# Test mise installation
mise doctor

# Test aliases/functions
source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/functions.zsh
k get pods  # Should work if you have kubectl
```

#### Option 4: Use Docker (Limited)

For testing shell configs only (no Homebrew/macOS-specific features):

```bash
docker run -it --rm -v ~/dotfiles:/dotfiles ubuntu:latest bash
apt update && apt install -y zsh git
# Test zsh configs only
```

### Full System Test

The safest way to test everything is with a virtual machine or spare Mac, but the options above cover most scenarios.

## Utility Scripts

### test-install.sh

Test what the install script would do without actually doing it:

```bash
./scripts/test-install.sh
```
