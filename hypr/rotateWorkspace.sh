#!/usr/bin/env bash
set -euo pipefail

# Move active workspace to the "next" monitor (sorted left→right), wrap around.
ws=$(hyprctl activeworkspace -j | jq -r .id)
mons_json=$(hyprctl monitors -j)

# Monitors sorted by X position
names=($(jq -r 'sort_by(.x)[] .name' <<<"$mons_json"))
(( ${#names[@]} >= 2 )) || exit 0

cur=$(jq -r '.[] | select(.focused==true).name' <<<"$mons_json")

# Find current index, then next index (wrap)
idx=-1
for i in "${!names[@]}"; do
  [[ "${names[$i]}" == "$cur" ]] && idx=$i && break
done
(( idx >= 0 )) || exit 1
next_idx=$(( (idx + 1) % ${#names[@]} ))
next="${names[$next_idx]}"

hyprctl dispatch moveworkspacetomonitor "$ws" "$next"
