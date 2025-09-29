#!/usr/bin/env bash
set -euo pipefail

# Get PID of the focused window (Alacritty)
pid="$(hyprctl activewindow -j | jq -r '.pid // empty')"
[ -z "$pid" ] && exec alacritty  # no window focused? just open normally

# BFS down the process tree to find an interactive shell child
queue=("$pid")
shell_pid=""
while ((${#queue[@]})); do
  parent="${queue[0]}"; queue=("${queue[@]:1}")
  # children of this parent
  for child in $(pgrep -P "$parent"); do
    cmd="$(ps -o comm= -p "$child" 2>/dev/null || true)"
    case "$cmd" in
      bash|zsh|fish)
        shell_pid="$child"; break 2
        ;;
      *)
        queue+=("$child")
        ;;
    esac
  done
done

# Resolve cwd and launch
if [ -n "$shell_pid" ] && [ -e "/proc/$shell_pid/cwd" ]; then
  cwd="$(readlink "/proc/$shell_pid/cwd" || echo "$HOME")"
else
  cwd="$HOME"
fi

exec alacritty --working-directory "$cwd"

