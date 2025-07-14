# Debugging Ctrl+Space Tmux Prefix on macOS

## 1. Common macOS Conflicts with Ctrl+Space

### System-level Conflicts:
1. **Spotlight Search** (most common conflict)
   - Go to System Settings → Keyboard → Keyboard Shortcuts → Spotlight
   - Check if "Show Spotlight search" is set to Ctrl+Space
   - Disable it or change to a different shortcut

2. **Input Source Switching**
   - System Settings → Keyboard → Keyboard Shortcuts → Input Sources
   - Check "Select the previous input source" - often set to Ctrl+Space
   - Disable or change this shortcut

3. **Mission Control**
   - System Settings → Keyboard → Keyboard Shortcuts → Mission Control
   - Check for any Ctrl+Space bindings

### Application Conflicts:
1. **Alfred** - Check preferences for Ctrl+Space hotkey
2. **Raycast** - Often uses Ctrl+Space as default
3. **BetterTouchTool** - Check for global shortcuts
4. **Karabiner-Elements** - Check for key remapping

## 2. Verify if Tmux is Receiving the Key Combination

### Method 1: Using tmux's show-keys
```bash
# In tmux, enter command mode (default prefix + :)
# Then run:
:show-keys

# Press Ctrl+Space to see what tmux receives
# Look for something like: C-Space
```

### Method 2: Check current prefix setting
```bash
# Show current prefix
tmux show-options -g prefix

# Should output: prefix C-Space
```

### Method 3: Use list-keys to verify bindings
```bash
# List all key bindings
tmux list-keys | grep prefix

# Should show:
# bind-key    -T prefix C-Space send-prefix
```

### Method 4: Test with send-keys
```bash
# Open a new tmux pane and run:
tmux send-keys C-Space

# If nothing happens, the key might be intercepted
```

## 3. Alternative Key Combinations for macOS

### Recommended Alternatives:
1. **C-a** (Classic GNU Screen style)
   ```bash
   set -g prefix C-a
   bind C-a send-prefix
   ```

2. **C-s** (Less commonly used in terminal)
   ```bash
   set -g prefix C-s
   bind C-s send-prefix
   ```

3. **C-q** (Rarely conflicts)
   ```bash
   set -g prefix C-q
   bind C-q send-prefix
   ```

4. **C-f** (If not using terminal search)
   ```bash
   set -g prefix C-f
   bind C-f send-prefix
   ```

5. **Backtick** (Easy to reach)
   ```bash
   set -g prefix `
   bind ` send-prefix
   ```

## 4. Test if Tmux Config is Loading Properly

### Step 1: Verify config location
```bash
# Check which config file tmux is using
tmux show-options -g | grep config

# Or start tmux with explicit config
tmux -f ~/.config/tmux/tmux.conf
```

### Step 2: Test config loading
```bash
# Add this to the top of your tmux.conf temporarily:
display-message "Config loaded from ~/.config/tmux/tmux.conf"

# Reload config
tmux source-file ~/.config/tmux/tmux.conf

# You should see the message appear
```

### Step 3: Check for errors
```bash
# Start tmux in verbose mode
tmux -vv

# Check for any error messages during startup
```

### Step 4: Verify specific settings
```bash
# After starting tmux, verify key settings:
tmux show-options -g | grep -E "prefix|mouse|status"
```

## 5. Quick Debugging Script

Create this script to test your setup:

```bash
#!/bin/bash
# save as check-tmux.sh

echo "=== Checking Tmux Configuration ==="
echo

echo "1. Current prefix setting:"
tmux show-options -g prefix 2>/dev/null || echo "Tmux not running"
echo

echo "2. Config file locations being checked:"
for conf in ~/.tmux.conf ~/.config/tmux/tmux.conf /etc/tmux.conf; do
    if [ -f "$conf" ]; then
        echo "   ✓ Found: $conf"
    else
        echo "   ✗ Not found: $conf"
    fi
done
echo

echo "3. Testing if Ctrl+Space is captured by macOS:"
echo "   Press Ctrl+Space now (wait 3 seconds)..."
read -t 3 -n 1
echo

echo "4. Current tmux version:"
tmux -V
echo

echo "5. Key bindings for prefix:"
tmux list-keys | grep -E "prefix|C-Space" | head -5
```

## 6. Terminal-Specific Issues

### iTerm2
- Check Preferences → Keys → Key Bindings for Ctrl+Space
- Look in Preferences → Profiles → Keys for profile-specific bindings
- Ensure "Send hex codes" isn't intercepting Ctrl+Space

### Terminal.app
- Generally has fewer conflicts but check:
  - Preferences → Profiles → Keyboard
  - Look for "Use Option as Meta key" settings

### Alacritty
- Check your alacritty.yml for key bindings:
  ```yaml
  key_bindings:
    - { key: Space, mods: Control, chars: "\x00" }
  ```

## 7. Final Troubleshooting Steps

1. **Completely disable system shortcuts:**
   ```bash
   # Temporarily disable Spotlight
   sudo mdutil -a -i off
   # Re-enable with: sudo mdutil -a -i on
   ```

2. **Test in safe mode:**
   - Start tmux with no config: `tmux -f /dev/null`
   - Manually set prefix: `:set -g prefix C-Space`
   - Test if it works

3. **Use tmux's debug mode:**
   ```bash
   tmux -vvv new-session -s debug
   # Check the tmux-*.log files created
   ```

4. **Alternative: Use a double-tap approach:**
   ```bash
   # In tmux.conf
   set -g prefix None
   bind -n C-Space if -F '#{s/empty//:status}' 'send C-Space' 'set status on; set prefix C-Space'
   bind -T prefix Space send C-Space
   ```

If Ctrl+Space still doesn't work after checking all these, consider using one of the alternative key combinations listed above. C-a or C-s are popular choices that rarely conflict on macOS.