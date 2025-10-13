#!/usr/bin/env bash
set -euo pipefail

pane_path=${1:-$PWD}
if [ -z "$pane_path" ]; then
  exit 0
fi

if command -v realpath >/dev/null 2>&1; then
  pane_path=$(realpath "$pane_path" 2>/dev/null || echo "$pane_path")
fi

while [ "$pane_path" != "/" ] && [ -n "$pane_path" ]; do
  if [ -d "$pane_path/.git" ]; then
    branch=$(git -C "$pane_path" symbolic-ref --short HEAD 2>/dev/null \
      || git -C "$pane_path" describe --tags --exact-match 2>/dev/null \
      || git -C "$pane_path" rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
      printf ' %s' "$branch"
    fi
    exit 0
  fi
  pane_path=$(dirname "$pane_path")
done

exit 0
