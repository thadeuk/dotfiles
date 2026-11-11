-- >>> murmur (managed: edit between markers) >>>
-- Load from hyprland.lua with:  require("murmur")   (copy this file to ~/.config/hypr/murmur.lua)
-- Hyprland owns the keyboard on Wayland, so each key runs the murmur CLI, which pokes the resident
-- app over its control socket. Use the FULL launcher path: the compositor's PATH lacks ~/.local/bin.

local murmur = "~/.local/bin/murmur"

hl.bind("SUPER + slash",     hl.dsp.exec_cmd(murmur .. " --toggle"))   -- open/close the pad

-- Tap or hold: Murmur tells them apart by watching the key (a tap is up within ~0.3s).
hl.bind("SUPER + Q",         hl.dsp.exec_cmd(murmur .. " --key ask"))   -- tap: ask a question · hold: ask out loud
hl.bind("SUPER + W",         hl.dsp.exec_cmd(murmur .. " --key write")) -- tap: rewrite the selection · hold: dictate
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(murmur .. " --review"))    -- pick the mode for the selection

-- A key per favourite mode, e.g. fix-only grammar:
-- hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd(murmur .. " --rewrite fix"))

-- Start resident at login so the first keypress doesn't wait for Electron to boot.
hl.on("hyprland.start", function() hl.exec_cmd(murmur .. " --background") end)
-- <<< murmur <<<
