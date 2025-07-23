# My Tmux Config

Quick reference for my tmux setup. Prefix is `Ctrl+Space`.

## Installation
```bash
# Install TPM and plugins
~/.config/tmux/install.sh
tmux
# Press Ctrl+Space then I (capital i) to install plugins
```

## Essential Key Bindings

### Navigation
- **Between tmux/nvim panes**: `Ctrl+h/j/k/l` (seamless navigation)
- **Between tmux panes only**: `Prefix + h/j/k/l`
- **Quick window switch**: `Option+1-9` (jump to window number)
- **Next/Previous window**: `Option+h/l`
- **Last window**: `Prefix + Space` or `Prefix + Tab`
- **Cycle panes**: `Prefix + n/p`

### Pane Management
- **Split horizontal**: `Prefix + |` or `Prefix + \`
- **Split vertical**: `Prefix + -` or `Prefix + _`
- **Zoom pane**: `Prefix + z` or `Prefix + f`
- **Kill pane**: `Prefix + x`
- **Resize panes**: `Prefix + H/J/K/L` (hold to repeat)

### Window Management
- **New window**: `Prefix + c`
- **Kill window**: `Prefix + X`
- **Rename window**: `Prefix + ,`
- **Move window**: `Prefix + </>` (left/right)

### Session Management
- **Session browser**: `Prefix + Ctrl+s`
- **Window browser**: `Prefix + Ctrl+w`
- **Detach**: `Prefix + d`

### Copy Mode (vim-style)
- **Enter copy mode**: `Prefix + Enter` or `Prefix + [`
- **Start selection**: `v`
- **Rectangle select**: `Ctrl+v`
- **Copy selection**: `y`
- **Search**: `/` (forward) or `?` (backward)

### Special Features
- **Popup window**: `Prefix + P` (80% screen size)
- **Git menu**: `Prefix + g` (status/diff/log/lazygit)
- **Quick test**: `Prefix + t` (runs test command)
- **Quick build**: `Prefix + b` (runs build command)
- **Telescope files**: `Prefix + F` (Neovim file picker)
- **Open in Finder**: `Prefix + o`
- **Reload config**: `Prefix + r`
- **Synchronize panes**: `Prefix + y` (type in all panes at once)
- **Clear screen**: `Prefix + Ctrl+l`
- **Clear scrollback**: `Ctrl+k`
- **Save pane history**: `Prefix + S` (prompts for filename)
- **Session switcher**: `Prefix + f` (fuzzy find sessions)
- **Last pane**: `Option+o`
- **70/30 split**: `Prefix + V` (perfect for code+terminal)
- **Repeat last command**: `Prefix + !` (in new pane)

## Plugins & Their Usage

### Extrakto (`Prefix + Tab` in copy mode)
Fuzzy find any text on screen and copy it. Super useful for grabbing URLs, IPs, or any text.

### tmux-open (`o` in copy mode)
Highlight a file path or URL and press `o` to open it. `Ctrl+o` opens in editor.

### tmux-copycat
- `Prefix + /` - Search with regex
- `Prefix + Ctrl+f` - Search file paths
- `Prefix + Ctrl+u` - Search URLs
- `Prefix + Ctrl+d` - Search digits
- `Prefix + Ctrl+g` - Search git status files

### Session Persistence
Sessions auto-save every 15 minutes. After system restart:
1. Open Terminal/iTerm
2. Start tmux - sessions will auto-restore
3. Neovim sessions are also restored

### URL Opening
- `Prefix + u` - List all URLs in pane with fzf

### tmux-thumbs (`Prefix + T`)
Copy any text on screen using keyboard hints (like Vimium for tmux). Great for copying IPs, hashes, paths.

### tmux-logging
- `Prefix + shift + p` - Toggle logging current pane
- `Prefix + alt + p` - Save visible pane contents
- `Prefix + alt + shift + p` - Save complete pane history

## Visual Indicators
- **Neovim windows**: Green with  icon
- **Active window**: Purple (or green if Neovim)
- **Zoomed pane**: 🔍 icon
- **Synchronized panes**: 🔗 icon
- **Prefix active**: Highlighted in status bar

## Pro Tips

1. **Quick command execution**: Use `Prefix + P` for popup instead of creating new panes
2. **Working with URLs**: Use `Prefix + u` to quickly open any URL visible in terminal
3. **Multiple cursors**: `Prefix + y` to type in all panes simultaneously
4. **Text extraction**: Use `Prefix + T` for hint-based copying or extrakto for fuzzy finding
5. **Git workflow**: `Prefix + g` opens a menu with common git operations
6. **Quick search**: `Prefix + /` enters copy mode with search ready
7. **Session management**: `Prefix + f` to quickly switch between projects
8. **Testing workflow**: `Prefix + t` runs tests without leaving current context

## Common Workflows

### Dev Setup
```
Prefix + |         # Split for editor/terminal
Ctrl+h/l          # Navigate between them
Prefix + V        # Quick 70/30 split (code/terminal)
Option+2          # Jump to second window
```

### Quick Testing
```
Prefix + t        # Run tests in popup
Prefix + b        # Run build in popup
Prefix + !        # Repeat last command in split
```

### Debugging
```
Prefix + z        # Zoom into problem pane
Prefix + Enter    # Copy mode to grab error text
/error           # Search for errors
v                # Select text
y                # Copy to clipboard
```

### Quick Git Check
```
Prefix + g        # Opens git menu
s                # Show status
d                # Show diff
l                # Show log
g                # Open lazygit
```

### Text Copying
```
Prefix + T        # Show hints on all text
type hint        # Copy that text
# OR
Prefix + Tab     # In copy mode for extrakto
select text      # Fuzzy find and copy
```

## Troubleshooting

- **Prefix not working?**: Check if another app is capturing Ctrl+Space
- **Colors look wrong?**: Make sure terminal supports true color
- **Can't navigate to Neovim?**: Install vim-tmux-navigator in Neovim
- **Plugins not loading?**: Run `Prefix + I` to install/update

## Mouse Support
Mouse is enabled - you can:
- Click to select panes
- Drag to resize
- Scroll to navigate history
- Select text to copy (auto-copies to clipboard)

## Quick Reference Card

### Most Used Commands
| Action | Key | Description |
|--------|-----|-------------|
| New split | `Prefix + \|` | Split vertically |
| Navigate | `Ctrl+h/j/k/l` | Move between panes (works with nvim) |
| Quick terminal | `Prefix + V` | 70/30 split for code/terminal |
| Run tests | `Prefix + t` | Test in popup |
| Git menu | `Prefix + g` | Git operations |
| Copy text | `Prefix + T` | Hint-based copy |
| Find files | `Prefix + F` | Telescope in popup |
| Switch session | `Prefix + f` | Fuzzy session finder |
| Zoom pane | `Prefix + z` | Toggle zoom |
| Last pane | `Option+o` | Jump to last active |

### Productivity Boosters
- **Incremental search**: `Prefix + /` starts search immediately
- **Save output**: `Prefix + S` saves pane history
- **Clear buffer**: `Ctrl+k` clears scrollback
- **Repeat command**: `Prefix + !` runs last command in new pane
- **Open in Finder**: `Prefix + o` opens current directory