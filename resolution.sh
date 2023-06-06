xrandr --newmode "1920x1200_60.00"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
xrandr --newmode "1920x1200_60.00"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync

xrandr --newmode "2560x1600_60.00"  348.50  2560 2760 3032 3504  1600 1603 1609 1658 -hsync +vsync

xrandr --addmode eDP1 "1920x1200_60.00"
xrandr --addmode eDP1 "2560x1600_60.00"

xrandr --output eDP1 --primary --mode 1920x1200_60.00
