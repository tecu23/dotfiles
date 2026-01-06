# Tmux Cheat Sheet

Complete reference for tmux keybindings and commands in your configuration.

---

## Table of Contents
1. [Prefix Key](#prefix-key)
2. [Sessions](#sessions)
3. [Windows](#windows)
4. [Panes](#panes)
5. [Copy Mode](#copy-mode)
6. [Plugins](#plugins)
7. [Configuration](#configuration)

---

## Prefix Key

**Custom Prefix:** `Ctrl-a` (changed from default `Ctrl-b`)

**Usage:** Press prefix key, then the command key
- Example: `Ctrl-a` then `c` creates a new window

**Quick Prefix Send:** `Ctrl-a` `Ctrl-a` sends `Ctrl-a` to the terminal

---

## Sessions

Sessions are the top-level containers in tmux.

### Session Management
| Command | Description |
|---------|-------------|
| `tmux` | Start new session |
| `tmux new -s <name>` | Start new session with name |
| `tmux ls` | List all sessions |
| `tmux attach` | Attach to last session |
| `tmux attach -t <name>` | Attach to named session |
| `tmux kill-session -t <name>` | Kill named session |

### Inside Tmux
| Keymap | Description |
|--------|-------------|
| `prefix` `d` | Detach from session |
| `prefix` `$` | Rename current session |
| `prefix` `s` | List and switch sessions |
| `prefix` `(` | Switch to previous session |
| `prefix` `)` | Switch to next session |

---

## Windows

Windows are like tabs in a browser.

### Window Management
| Keymap | Description |
|--------|-------------|
| `prefix` `c` | Create new window |
| `prefix` `&` | Kill current window (with confirmation) |
| `prefix` `,` | Rename current window |
| `prefix` `w` | List all windows (interactive) |

### Window Navigation
| Keymap | Description |
|--------|-------------|
| `prefix` `n` | Next window |
| `prefix` `p` | Previous window |
| `prefix` `l` | Last active window |
| `prefix` `0-9` | Switch to window by number |
| `M-H` | **Previous window** (Alt+Shift+H) |
| `M-L` | **Next window** (Alt+Shift+L) |

**Note:** `M-H` and `M-L` are custom bindings that work without prefix!

---

## Panes

Panes split windows into multiple sections.

### Pane Creation (tmux-pain-control)
| Keymap | Description |
|--------|-------------|
| `prefix` `\|` | Split pane vertically (left/right) |
| `prefix` `-` | Split pane horizontally (top/bottom) |
| `prefix` `\` | Split full width vertically |
| `prefix` `_` | Split full height horizontally |

### Pane Navigation (vim-tmux-navigator)
| Keymap | Description |
|--------|-------------|
| `Ctrl-h` | Move to left pane (or vim split) |
| `Ctrl-j` | Move to lower pane (or vim split) |
| `Ctrl-k` | Move to upper pane (or vim split) |
| `Ctrl-l` | Move to right pane (or vim split) |

**Note:** These work seamlessly between tmux panes and vim splits!

### Pane Resizing (tmux-pain-control)
| Keymap | Description |
|--------|-------------|
| `prefix` `Shift-H` | Resize pane left |
| `prefix` `Shift-J` | Resize pane down |
| `prefix` `Shift-K` | Resize pane up |
| `prefix` `Shift-L` | Resize pane right |
| `prefix` `<` | Resize pane left (5 cells) |
| `prefix` `>` | Resize pane right (5 cells) |

### Pane Management
| Keymap | Description |
|--------|-------------|
| `prefix` `x` | Kill current pane (with confirmation) |
| `prefix` `z` | Toggle pane zoom (fullscreen) |
| `prefix` `!` | Break pane into new window |
| `prefix` `o` | Cycle through panes |
| `prefix` `;` | Toggle last active pane |
| `prefix` `q` | Show pane numbers (type number to jump) |
| `prefix` `{` | Swap pane with previous |
| `prefix` `}` | Swap pane with next |

### Pane Layouts
| Keymap | Description |
|--------|-------------|
| `prefix` `Space` | Cycle through layouts |
| `prefix` `Alt-1` | Even horizontal layout |
| `prefix` `Alt-2` | Even vertical layout |
| `prefix` `Alt-3` | Main horizontal layout |
| `prefix` `Alt-4` | Main vertical layout |
| `prefix` `Alt-5` | Tiled layout |

---

## Copy Mode

Copy mode allows you to scroll through output and copy text.

### Entering Copy Mode
| Keymap | Description |
|--------|-------------|
| `prefix` `[` | Enter copy mode |
| `prefix` `PgUp` | Enter copy mode and scroll up |

### Navigation in Copy Mode (vi-mode)
| Keymap | Description |
|--------|-------------|
| `h/j/k/l` | Move cursor (vi keys) |
| `w/b` | Jump word forward/backward |
| `0/$` | Jump to start/end of line |
| `g/G` | Jump to top/bottom |
| `Ctrl-u/d` | Scroll half page up/down |
| `Ctrl-b/f` | Scroll full page up/down |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |

### Copying Text
| Keymap | Description |
|--------|-------------|
| `Space` | Start selection |
| `Enter` | Copy selection and exit |
| `v` | Toggle line/block selection |
| `Escape` | Exit copy mode |

### Pasting
| Keymap | Description |
|--------|-------------|
| `prefix` `]` | Paste most recent buffer |
| `prefix` `=` | List all paste buffers |
| `prefix` `#` | List all paste buffers (alternative) |

---

## Plugins

Your tmux is enhanced with these plugins:

### tmux-pain-control
**Enhanced pane management** with intuitive keybindings
- Easy pane splitting with `|` and `-`
- Vim-style pane resizing
- See [Pane Creation](#pane-creation-tmux-pain-control) section

### vim-tmux-navigator
**Seamless navigation** between tmux panes and vim splits
- Use `Ctrl-h/j/k/l` to navigate anywhere
- No need to think about tmux vs vim boundaries
- See [Pane Navigation](#pane-navigation-vim-tmux-navigator) section

### tmux-sensible
**Sane defaults** for tmux
- UTF-8 support
- Better scrollback
- Improved key bindings
- Address many common pain points

### tmux-logging
**Session logging capabilities**

| Keymap | Description |
|--------|-------------|
| `prefix` `Shift-P` | Toggle logging current pane |
| `prefix` `Alt-p` | Save complete history to file |
| `prefix` `Alt-P` | Clear pane history |

**Log Location:** `~/tmux-logs/`

### tmux-mountain-theme
**Custom theme** (Tecu23/tmux-mountain-theme)
- Clean status bar at top
- Mountain colorscheme
- Minimal and focused design

---

## Configuration

### General Settings
- **Terminal:** xterm-256color with RGB support
- **Escape Time:** 0ms (no delay)
- **Mouse:** Enabled
- **History:** 10,000 lines
- **Status Position:** Top

### Reload Configuration
| Keymap | Description |
|--------|-------------|
| `prefix` `r` | Reload tmux configuration |

Shows "Reloaded!" message on success.

### Configuration File
- **Location:** `~/.config/tmux/tmux.conf`
- **Edit:** `vim ~/.config/tmux/tmux.conf`
- **Reload:** `prefix` + `r` or `tmux source ~/.config/tmux/tmux.conf`

---

## Common Workflows

### Starting a Development Session
```bash
# Create named session
tmux new -s dev

# Inside tmux, create windows
prefix c    # New window for editor
prefix ,    # Rename to "editor"
prefix c    # New window for server
prefix ,    # Rename to "server"
prefix c    # New window for tests
prefix ,    # Rename to "tests"

# Split panes as needed
prefix |    # Split for side-by-side code
prefix -    # Split for terminal below
```

### Navigating Like a Pro
```bash
M-L / M-H              # Quick window switching (no prefix!)
Ctrl-h/j/k/l          # Navigate panes/vim seamlessly
prefix z              # Zoom current pane
prefix w              # Visual window picker
```

### Working with Multiple Sessions
```bash
# Outside tmux
tmux new -s work
tmux new -s personal
tmux new -s project1

# Inside tmux
prefix s              # List and switch sessions
prefix d              # Detach
tmux attach -t work   # Reattach to specific session
```

### Copying Text Workflow
```bash
prefix [              # Enter copy mode
/search_term          # Search for text
n                     # Jump to next match
Space                 # Start selection
Enter                 # Copy and exit
prefix ]              # Paste
```

---

## Tips & Tricks

### Quick Commands
1. **Kill frozen pane:** `prefix` + `x`
2. **Swap panes:** `prefix` + `{` or `}`
3. **Zoom pane:** `prefix` + `z` (toggle fullscreen)
4. **Show pane numbers:** `prefix` + `q` (then type number)
5. **Last window:** `prefix` + `l` (toggle between two windows)

### Productivity Hacks
- Use `M-L` / `M-H` for rapid window switching without prefix
- Use `Ctrl-h/j/k/l` for seamless navigation (works in vim too!)
- Name your windows with `prefix` + `,` for easy identification
- Zoom panes with `prefix` + `z` when you need focus
- Enable logging with `prefix` + `Shift-P` for important sessions

### Mouse Support
- Click pane to switch
- Click window in status bar to switch
- Drag pane border to resize
- Scroll to view history (enters copy mode)
- Double-click to select word
- Right-click to paste (if terminal supports it)

---

## Troubleshooting

### Common Issues

**Colors look wrong?**
- Check `$TERM` is set correctly: `echo $TERM`
- Should be `xterm-256color` or `tmux-256color`

**Prefix not working?**
- Remember it's `Ctrl-a`, not `Ctrl-b`
- Check with `tmux show-options -g prefix`

**Navigator not working between vim and tmux?**
- Ensure vim-tmux-navigator plugin is installed in both tmux and vim
- Check vim has the corresponding plugin

**Can't scroll?**
- Use `prefix` + `[` to enter copy mode
- Or enable mouse mode and scroll with mouse wheel

---

## Command Line Interface

### Useful tmux Commands
```bash
# Session management
tmux ls                          # List sessions
tmux new -s <name>              # New named session
tmux attach -t <name>           # Attach to session
tmux kill-session -t <name>     # Kill session
tmux kill-server                # Kill all sessions

# Window management
tmux list-windows               # List windows
tmux select-window -t <name>    # Switch to window

# Information
tmux info                       # Show tmux info
tmux list-keys                  # List all key bindings
tmux list-commands              # List all commands
```

---

## File Location

This configuration is in: `/Users/andrei.teculescu/dotfiles/tmux/`

Key files:
- `tmux.conf` - Main configuration
- `plugins/` - TPM plugins directory

---

**Last Updated:** 2026-01-06
