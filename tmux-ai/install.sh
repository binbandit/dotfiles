#!/bin/bash

# Install Tmux Plugin Manager
echo "Installing Tmux Plugin Manager..."
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

echo "Installation complete!"
echo ""
echo "To finish setup:"
echo "1. Start tmux: tmux"
echo "2. Press Ctrl+Space then I (capital i) to install plugins"
echo ""
echo "Key bindings:"
echo "- Prefix: Ctrl+Space"
echo "- Split horizontal: Prefix + | or \\"
echo "- Split vertical: Prefix + - or _"
echo "- Navigate panes: Ctrl+h/j/k/l (works with Neovim)"
echo "- Switch windows: Option+h/l or Option+1-9"
echo "- Copy mode: Prefix + Enter"
echo "- Reload config: Prefix + r"
echo "- Popup window: Prefix + P"
echo "- Lazygit popup: Prefix + g"
echo ""
echo "Neovim windows are highlighted in green with a  icon!"