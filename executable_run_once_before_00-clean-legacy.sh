#!/usr/bin/env bash
set -euo pipefail

# Remove stray files created by previous bootstrap attempts.
rm -f "$HOME/Brewfile"
rm -f "$HOME"/run_once_after_* "$HOME"/run_onchange_after_* 2>/dev/null || true
rm -f "$HOME"/run_once_before_* "$HOME"/run_onchange_before_* 2>/dev/null || true

# Remove legacy Fish abbreviation file if it exists.
rm -f "$HOME/.config/fish/conf.d/abbr.fish"

exit 0
