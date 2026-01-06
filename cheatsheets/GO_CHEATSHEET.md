# Go Development Cheat Sheet for Neovim

Complete reference for all Go-related keybindings and features in your Neovim configuration.

---

## Table of Contents
1. [Go-Specific Commands](#go-specific-commands)
2. [Code Generation](#code-generation)
3. [Testing & Coverage](#testing--coverage)
4. [LSP Navigation](#lsp-navigation)
5. [LSP Actions](#lsp-actions)
6. [Diagnostics](#diagnostics)
7. [Formatting & Linting](#formatting--linting)
8. [Debugging (DAP)](#debugging-dap)
9. [Telescope (LSP)](#telescope-lsp)
10. [Additional LSP Features](#additional-lsp-features)

---

## Go-Specific Commands

### Struct Tags
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>ggsj` | `:GoAddTag json` | Add JSON struct tags |
| `<leader>ggsy` | `:GoAddTag yaml` | Add YAML struct tags |
| `<leader>ggsv` | `:GoAddTag validate` | Add validation struct tags |

### Code Generation
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>ggcmt` | `:GoCmt` | Generate doc comments |
| `<leader>gge` | `:GoIfErr` | Generate if err statement |
| `<leader>ggf` | `:GoFillStruct` | Fill struct with default values |
| `<leader>ggi` | `:GoImport` | Import package |

### Module Management
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>ggmt` | `:GoModTidy` | Run go mod tidy |

### Build & Run
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>ggb` | `:GoBuild` | Build Go project |
| `<leader>ggr` | `:GoRun` | Run Go file/project |
| `<leader>ggd` | `:GoDoc` | Show documentation |

---

## Testing & Coverage

| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>ggt` | `:GoTest` | Run all tests in current package |
| `<leader>ggT` | `:GoTestFunc` | Run test function under cursor |
| `<leader>ggc` | `:GoCoverage` | Show test coverage |

### Additional Test Commands (Available)
- `:GoTestFile` - Run tests in current file
- `:GoTestPkg` - Run tests in current package
- `:GoAddTest` - Generate test for function
- `:GoAddExpTest` - Generate test for exported functions
- `:GoAddAllTest` - Generate tests for all functions

---

## LSP Navigation

### Go To Definition/Reference
| Keymap | Command | Description |
|--------|---------|-------------|
| `gd` | LSP Definition | Go to definition (Telescope) |
| `gD` | LSP Declaration | Go to declaration |
| `gI` | LSP Implementation | Go to implementation (Telescope) |
| `gr` | LSP References | Show references (Telescope) |
| `<leader>D` | LSP Type Definition | Go to type definition (Telescope) |

### Hover & Signature
| Keymap | Command | Description |
|--------|---------|-------------|
| `K` | LSP Hover | Show hover documentation |
| `gs` | LSP Signature Help | Show signature help |

### Symbols
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>ds` | Telescope LSP | Document symbols |
| `<leader>ws` | Telescope LSP | Workspace symbols |

---

## LSP Actions

### Code Actions & Refactoring
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>ca` | LSP Code Action | Show code actions (n/v mode) |
| `<leader>rn` | LSP Rename | Rename symbol |

### Workspace Management
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>wa` | LSP Add Workspace | Add workspace folder |
| `<leader>wr` | LSP Remove Workspace | Remove workspace folder |
| `<leader>wl` | LSP List Workspaces | List workspace folders |

### Code Lens
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>cl` | LSP Code Lens | Run code lens action |
| `<leader>cr` | LSP Code Lens Refresh | Refresh code lens |

**Note:** gopls code lenses include:
- Generate (run `go generate`)
- Run test (run specific test)
- Tidy (run `go mod tidy`)
- Upgrade dependency
- Run vulncheck

---

## Diagnostics

### Navigation
| Keymap | Command | Description |
|--------|---------|-------------|
| `[d` | Previous Diagnostic | Go to previous diagnostic |
| `]d` | Next Diagnostic | Go to next diagnostic |
| `<leader>do` | Show Line Diagnostics | Open diagnostic float |
| `<leader>q` | Location List | Set location list with diagnostics |

### Trouble (Enhanced Diagnostics UI)
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>xx` | Toggle Trouble | Toggle trouble panel |
| `<leader>xw` | Workspace Diagnostics | Show workspace diagnostics |
| `<leader>xd` | Document Diagnostics | Show document diagnostics |
| `<leader>xl` | Location List | Show location list |
| `<leader>xq` | Quickfix | Show quickfix list |

### Commands
- `:DiagnosticsToggle` - Enable/disable diagnostics globally

---

## Formatting & Linting

### Formatting
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>f` | Format Buffer | Format current buffer (n/v mode) |

**Auto-format on save:** Enabled by default using `goimports`
- Organizes imports automatically
- Formats code with `gofmt`
- Timeout: 3000ms

### Format Commands
- `:Format` - Format buffer or range
- `:FormatToggle` - Toggle format on save globally

### Linting
**Active linter:** `golangci-lint`
- Runs automatically on file open/save
- Configuration: Uses project's `.golangci.yml` if present

---

## Debugging (DAP)

**DAP Support:** Enabled with nvim-dap and go.nvim
- Delve debugger integration
- DAP UI support enabled

### Available Commands
- `:GoDebug` - Start debug session
- `:GoDebugStop` - Stop debug session
- `:GoBreakToggle` - Toggle breakpoint

**Note:** DAP keymaps depend on your nvim-dap configuration (not currently set up with custom keymaps)

---

## Telescope (LSP)

### Search & Navigation
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>sf` | Find Files | Search files in project |
| `<leader>sg` | Live Grep | Search text in project |
| `<leader>sw` | Grep String | Search word under cursor |
| `<leader>sd` | Diagnostics | Search diagnostics |
| `<leader>sr` | Resume | Resume last Telescope search |
| `<leader>ss` | Select Telescope | Show Telescope pickers |

### LSP-Specific Telescope Searches
These are automatically used when you use the LSP keymaps above:
- `gd` uses `telescope.lsp_definitions`
- `gI` uses `telescope.lsp_implementations`
- `gr` uses `telescope.lsp_references`
- `<leader>D` uses `telescope.lsp_type_definitions`

---

## Additional LSP Features

### Inlay Hints
| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>ih` | Toggle Inlay Hints | Toggle inlay hints on/off |

**Inlay hint types (when enabled):**
- Variable type hints
- Parameter names in function calls
- Composite literal field names
- Constant values
- Function type parameters
- Range variable types

### Auto-complete
- **Trigger:** Start typing, auto-complete suggestions appear
- **Navigate:** `<C-n>` (next), `<C-p>` (previous)
- **Accept:** `<CR>` (Enter) or `<Tab>`
- Supports:
  - Unimported package completion
  - Function signatures with placeholders
  - Documentation in completion menu

### Document Highlight
- **Automatic:** Cursor hold highlights same symbol
- References to symbol under cursor are highlighted
- Highlights clear on cursor move

---

## gopls Configuration Summary

Your gopls is configured with:
- **Formatting:** gofmt (not gofumpt)
- **Static Analysis:** staticcheck, nilness, shadow, fieldalignment, unusedparams, unusedwrite, composites
- **Semantic Tokens:** Enabled
- **Build Tags:** `-tags=integration`
- **Code Lenses:** generate, test, tidy, upgrade_dependency, run_govulncheck
- **Workspace Support:** go.work, go.mod detection

---

## User Commands

### LSP Commands
- `:LspInfo` - Show LSP server information and status
- `:LspLog` - Open LSP log file
- `:LspRestart` - Restart all LSP servers
- `:Format` - Format document or range
- `:FormatToggle` - Toggle auto-format on save
- `:DiagnosticsToggle` - Toggle diagnostics

### go.nvim Commands
Run `:GoHelp` to see all available go.nvim commands.

Common commands:
- `:GoInstallBinaries` - Install/update required Go tools
- `:GoMod tidy` - Run go mod tidy
- `:GoFmt` - Format current file
- `:GoImports` - Organize imports
- `:GoFillStruct` - Fill struct with default values
- `:GoIfErr` - Generate if err check
- `:GoCmt` - Generate comment
- `:GoImpl` - Generate interface implementation
- `:GoTestAdd` - Add test for function
- `:GoGenerate` - Run go generate

---

## Tips & Tricks

### Quick Actions
1. **Fix imports:** Just save the file - `goimports` runs automatically
2. **Add struct tags:** Visual select fields → `<leader>ggsj`
3. **Run test:** Cursor on test function → `<leader>ggT`
4. **View docs:** Cursor on symbol → `K`
5. **Rename symbol:** Cursor on symbol → `<leader>rn`
6. **See all references:** Cursor on symbol → `gr`

### Code Lens Actions
When you see code lens hints above functions:
1. Position cursor on the lens line
2. Press `<leader>cl` to run the action
3. Common lenses: "run test", "run package tests", "upgrade dependency"

### Diagnostic Workflow
1. `]d` / `[d` - Navigate through errors
2. `<leader>do` - See detailed error at cursor
3. `<leader>ca` - Quick fix if available
4. `<leader>xd` - See all errors in Trouble panel

### Test Workflow
1. Write test function
2. `<leader>ggT` - Run test under cursor
3. `<leader>ggc` - View coverage
4. `<leader>ggt` - Run all package tests

---

## File Location

This configuration is in: `/Users/andrei.teculescu/dotfiles/nvim/`

Key files:
- `lua/tecu/plugins/go.lua` - go.nvim configuration
- `lua/tecu/lsp/servers/gopls.lua` - gopls LSP configuration
- `lua/tecu/lsp/init.lua` - LSP keymaps and setup
- `lua/tecu/plugins/lsp.lua` - conform (formatter) and nvim-lint configuration

---

**Last Updated:** 2026-01-06
