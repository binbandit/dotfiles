#!/usr/bin/env bash
set -euo pipefail

if pgrep -f "supermaven" >/dev/null 2>&1; then
  printf ' AI'
  exit 0
fi

printf 'AI off'
