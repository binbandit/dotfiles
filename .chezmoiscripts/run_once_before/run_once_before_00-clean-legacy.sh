#!/usr/bin/env bash
set -euo pipefail

rm -f "$HOME/Brewfile"
rm -f "$HOME"/run_once_after_* "$HOME"/run_onchange_after_* "$HOME"/run_once_before_* "$HOME"/run_onchange_before_* 2>/dev/null || true
rm -f "$HOME/.config/fish/conf.d/abbr.fish" "$HOME/.config/fish/conf.d/10-abbr.fish.tmpl" 2>/dev/null || true

exit 0
