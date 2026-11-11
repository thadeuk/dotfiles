#!/usr/bin/env bash
# Runs omarchy-theme-apply in a sandbox $HOME with session commands stubbed,
# then checks the generated configs.

set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
sandbox="$(mktemp -d)"
trap 'rm -rf "$sandbox"' EXIT

stubs="$sandbox/stubs"
mkdir -p "$stubs"
for cmd in hyprctl notify-send gsettings makoctl chromium google-chrome google-chrome-stable microsoft-edge microsoft-edge-stable brave; do
  printf '#!/bin/sh\nexit 0\n' >"$stubs/$cmd"
done
printf '#!/bin/sh\nexit 1\n' >"$stubs/pgrep"
chmod +x "$stubs"/*

home="$sandbox/home"
mkdir -p "$home/.config/omarchy" "$home/.config/"{alacritty,waybar,mako,wofi,xsettingsd}
ln -s "$repo/default-theme" "$home/.config/omarchy/default-theme"

fail=0

# Semantic colors.toml (omacom/omarchy schema): named colors, no color0..15.
theme="$home/.config/omarchy/themes/semantic"
mkdir -p "$theme"
cat >"$theme/colors.toml" <<'EOF'
accent = "#407e70"
muted = "#1e1e1e"
background = "#000000"
foreground = "#efefef"
bright_foreground = "#ffffff"
red = "#d35f5f"
green = "#8a9a7b"
yellow = "#ffc107"
blue = "#8a9fbe"
magenta = "#c1a1c1"
cyan = "#88aabb"
bright_red = "#b91c1c"
bright_green = "#a5b799"
bright_yellow = "#f59e0b"
bright_blue = "#a4bbdd"
bright_magenta = "#d9b9d9"
bright_cyan = "#a2c4d3"
EOF

HOME="$home" PATH="$stubs:$PATH" "$repo/omarchy-theme-apply" semantic >/dev/null

generated="$home/.config/omarchy/generated"

if ! grep -q 'inactive_border = "rgba(000000aa)"' "$generated/hyprland-theme.lua"; then
  echo "FAIL: inactive_border not derived from background"
  fail=1
fi

if grep -q '= ""' "$generated/alacritty.toml"; then
  echo "FAIL: alacritty.toml has empty colors"
  fail=1
fi

if ! grep -q 'cursor = "#ffffff"' "$generated/alacritty.toml"; then
  echo "FAIL: cursor not derived from bright_foreground"
  fail=1
fi

(( fail )) || echo "PASS"
exit "$fail"
