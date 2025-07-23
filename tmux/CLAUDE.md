# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a tmux configuration repository containing a sophisticated, developer-focused tmux setup optimized for macOS and Neovim integration.

## Key Files

- `tmux.conf`: Main configuration file with all settings, key bindings, and plugin configurations
- `README.md`: User documentation explaining keybindings and workflows
- `install.sh`: Installation script for setting up Tmux Plugin Manager (TPM)

## Commands

### Testing and Building
The configuration includes intelligent project detection for common development tasks:

- **Test**: `Prefix + t` runs: `npm test || cargo test || go test ./... || pytest || echo 'No test command found'`
- **Build**: `Prefix + b` runs: `make || npm run build || cargo build || go build || echo 'No build command found'`

### Plugin Management
- Install/update plugins: Press `Ctrl+Space` then `I` (capital i) inside tmux
- Plugins are managed via TPM and stored in `~/.config/tmux/plugins/`

## Architecture and Key Patterns

### Custom Prefix Key
Uses `Ctrl+Space` instead of default `Ctrl+b` for ergonomic access without conflicting with common editor shortcuts.

### Neovim Integration
Seamless navigation between tmux and Neovim panes using `Ctrl+h/j/k/l`. Windows containing Neovim are visually distinguished with green color and  icon in the status bar.

### Popup Windows
Extensive use of popup windows (80% screen size) for temporary tasks like running tests, builds, git operations, and file navigation. Access via `Prefix + P` for general popup or specific shortcuts for dedicated tasks.

### Visual Status Indicators
- Active Neovim windows: Green with  icon
- Regular active windows: Purple
- Zoomed panes: 🔍 icon
- Synchronized panes: 🔗 icon

### Session Persistence
Auto-saves sessions every 15 minutes using tmux-resurrect and tmux-continuum plugins. Sessions automatically restore on tmux startup.

## Development Patterns

When modifying this configuration:

1. Key bindings follow vim-style conventions where applicable
2. macOS-specific optimizations use Option key for window navigation
3. Popup windows are preferred over creating new panes for temporary tasks
4. Visual feedback is important - use status bar indicators for modes/states
5. Plugin selection is curated for developer productivity without bloat

## Important Conventions

- Window numbering starts at 1 (not 0) for easier keyboard access
- All pane splits preserve the current working directory
- Copy mode uses vi bindings with macOS clipboard integration via pbcopy
- Direct window access uses `Option+1-9` for quick switching
- Git operations are centralized in a menu accessible via `Prefix + g`