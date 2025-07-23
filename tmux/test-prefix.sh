#!/bin/bash
# Test script for tmux Ctrl+Space prefix issues

echo "=== Tmux Prefix Debugging Tool ==="
echo

# Check if tmux is running
if ! command -v tmux &> /dev/null; then
    echo "ERROR: tmux is not installed"
    exit 1
fi

echo "1. Tmux version:"
tmux -V
echo

echo "2. Checking for config files:"
configs=(
    "$HOME/.tmux.conf"
    "$HOME/.config/tmux/tmux.conf"
    "/etc/tmux.conf"
)

found_config=false
for conf in "${configs[@]}"; do
    if [ -f "$conf" ]; then
        echo "   ✓ Found: $conf"
        found_config=true
    else
        echo "   ✗ Not found: $conf"
    fi
done
echo

if [ -n "$TMUX" ]; then
    echo "3. Currently inside tmux session"
    echo "   Session name: $(tmux display-message -p '#S')"
    echo
    
    echo "4. Current prefix setting:"
    tmux show-options -g prefix
    echo
    
    echo "5. Prefix-related key bindings:"
    tmux list-keys | grep -E "(prefix|C-Space)" | head -10
    echo
    
    echo "6. Testing prefix key:"
    echo "   Press your prefix key followed by '?' to see all bindings"
    echo "   Press 'q' to exit the help screen"
    echo
else
    echo "3. Not currently in a tmux session"
    echo
    echo "Starting a test session..."
    echo "Once in tmux, run this script again to see more diagnostics"
    echo
    read -p "Press Enter to start a test tmux session..."
    tmux new-session -s test-prefix
fi

echo
echo "=== Common macOS Shortcuts to Check ==="
echo "1. System Settings → Keyboard → Keyboard Shortcuts → Spotlight"
echo "   - Disable 'Show Spotlight search' if it's using Ctrl+Space"
echo
echo "2. System Settings → Keyboard → Keyboard Shortcuts → Input Sources"
echo "   - Disable 'Select the previous input source' if it's using Ctrl+Space"
echo
echo "3. Check these apps for Ctrl+Space conflicts:"
echo "   - Raycast"
echo "   - Alfred"
echo "   - BetterTouchTool"
echo "   - Karabiner-Elements"
echo

# If we can detect some common conflicts
if command -v defaults &> /dev/null; then
    echo "=== Checking some system shortcuts ==="
    
    # Try to check Spotlight shortcut (this might not work on all macOS versions)
    spotlight_key=$(defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys 2>/dev/null | grep -A5 "64\s*=" | grep -o "65536" || echo "not found")
    if [ "$spotlight_key" = "65536" ]; then
        echo "⚠️  Spotlight might be using Ctrl+Space"
    fi
    
    echo
fi

echo "=== Quick Fix Suggestions ==="
echo "1. Try alternative prefix keys by adding to ~/.config/tmux/tmux.conf:"
echo "   set -g prefix C-a    # Classic screen-style"
echo "   set -g prefix C-s    # Rarely conflicts"
echo "   set -g prefix C-q    # Also rarely used"
echo
echo "2. Reload tmux config with: tmux source-file ~/.config/tmux/tmux.conf"
echo "   Or press: <current-prefix> + r (if using the provided config)"