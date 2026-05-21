#!/usr/bin/env bash
# Waybar custom module: count of pacman + AUR updates, tooltip lists them.

set -uo pipefail

# Test hook: OMARCHY_UPDATES_FAKE=<n> forces a fake "n updates pending" output.
if [[ -n "${OMARCHY_UPDATES_FAKE:-}" ]]; then
  jq -nc --arg n "${OMARCHY_UPDATES_FAKE}" \
    '{text:("  " + $n), tooltip:("Test mode: pretending " + $n + " updates pending"), class:"updates-available"}'
  exit 0
fi

pacman_updates=$(checkupdates 2>/dev/null || true)
aur_updates=$(pikaur -Qua 2>/dev/null || true)

pacman_count=$(printf '%s' "$pacman_updates" | grep -c . || true)
aur_count=$(printf '%s' "$aur_updates" | grep -c . || true)
total=$((pacman_count + aur_count))

if (( total == 0 )); then
  jq -nc '{text:"", tooltip:"System up to date", class:"updates-none"}'
  exit 0
fi

tooltip=""
if (( pacman_count > 0 )); then
  tooltip+="Pacman ($pacman_count):"$'\n'"$pacman_updates"
fi
if (( aur_count > 0 )); then
  [[ -n "$tooltip" ]] && tooltip+=$'\n\n'
  tooltip+="AUR ($aur_count):"$'\n'"$aur_updates"
fi

jq -nc --arg t "  $total" --arg tip "$tooltip" \
  '{text:$t, tooltip:$tip, class:"updates-available"}'
