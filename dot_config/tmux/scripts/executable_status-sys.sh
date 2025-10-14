#!/usr/bin/env bash
set -euo pipefail

# CPU load (1 minute average)
if command -v sysctl >/dev/null 2>&1; then
  load=$(sysctl -n vm.loadavg 2>/dev/null | awk '{printf "%.2f", $1}')
else
  load=$(uptime | awk -F'load averages?: ' '{print $2}' | cut -d',' -f1 | xargs)
fi

# Memory pressure (macOS) or fallback to free
if command -v memory_pressure >/dev/null 2>&1; then
  mem=$(memory_pressure 2>/dev/null | awk -F': ' '/System-wide memory free percentage/ {gsub("%","",$2); printf "%.0f%%", $2}')
  mem_display="󰍛 ${mem} free"
elif command -v free >/dev/null 2>&1; then
  mem=$(free -m | awk '/Mem:/ {printf "%.0f%%", ($3/$2)*100}')
  mem_display="󰍛 ${mem} used"
else
  mem_display="󰍛 n/a"
fi

# Battery percentage (macOS or Linux upower)
battery=""
if command -v pmset >/dev/null 2>&1; then
  batt=$(pmset -g batt | awk 'NR==2 {gsub("%", "", $3); gsub(";", "", $3); print $3}')
  if [ -n "$batt" ]; then
    battery="🔋 ${batt}%"
  fi
elif command -v upower >/dev/null 2>&1; then
  device=$(upower -e | grep -E 'battery|DisplayDevice' | head -n1)
  if [ -n "$device" ]; then
    batt=$(upower -i "$device" | awk '/percentage/ {print $2}' )
    if [ -n "$batt" ]; then
      battery="🔋 ${batt}"
    fi
  fi
fi

if [ -z "$battery" ]; then
  battery="🔋 n/a"
fi

printf ' %s  %s  %s' "$load" "$mem_display" "$battery"
