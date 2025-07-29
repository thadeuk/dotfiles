#!/bin/sh
xrandr --output eDP-1 --primary --mode 1920x1200 --pos 1920x0 --rotate normal --output DP-2 --mode 2560x1600 --pos 0x0 --rotate normal 
xrandr --output DP-2 --scale 0.75x0.75 --output eDP-1 --scale 1x1
