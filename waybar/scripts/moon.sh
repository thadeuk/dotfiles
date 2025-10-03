#!/usr/bin/env bash
# moon_phase.sh — local moon phase for Waybar (no network)
# deps: awk (for floating point)

set -euo pipefail

# Algorithm:
# - Use a known new moon epoch (2000-01-06 18:14:00 UTC = 947182440)
# - Synodic month = 29.53058867 days
# - Compute current phase age and illumination
#
# This is an approximation good enough for UI display.

# Seconds since epoch (UTC)
now_s=$(date -u +%s)

# Constants
newmoon_ref_s=947182440                # 2000-01-06 18:14:00Z
synodic_days=29.53058867
day_s=86400

# Compute with awk for float math
calc=$(awk -v now="$now_s" -v ref="$newmoon_ref_s" -v syn="$synodic_days" -v day="$day_s" '
  BEGIN {
    # age in days since reference new moon, reduced modulo one synodic month
    phase_days = fmod(((now - ref) / day), syn);
    if (phase_days < 0) phase_days += syn;

    # phase fraction in [0,1)
    f = phase_days / syn;

    # illumination ~ 0.5 * (1 - cos(2*pi*f))
    pi = 3.14159265358979323846;
    illum = 0.5 * (1 - cos(2 * pi * f)) * 100.0;

    # bucket to textual phase (8 primary states + waxing/waning crescents/gibbous)
    phase = "";
    if      (f < 0.03 || f >= 0.97)                phase = "New Moon";
    else if (f < 0.22 && f >= 0.03) {
      if (f < 0.11)                                phase = "Waxing Crescent";
      else                                         phase = "First Quarter";
    }
    else if (f < 0.47 && f >= 0.22) {
      if (f < 0.36)                                phase = "Waxing Gibbous";
      else                                         phase = "Full Moon";
    }
    else if (f < 0.72 && f >= 0.47) {
      if (f < 0.61)                                phase = "Waning Gibbous";
      else                                         phase = "Last Quarter";
    }
    else { # 0.72 .. 0.97
      phase = "Waning Crescent";
    }

    # pick icon
    icon = "🌙";
    if      (phase == "New Moon")         icon = "🌑";
    else if (phase == "Waxing Crescent")  icon = "🌒";
    else if (phase == "First Quarter")    icon = "🌓";
    else if (phase == "Waxing Gibbous")   icon = "🌔";
    else if (phase == "Full Moon")        icon = "🌕";
    else if (phase == "Waning Gibbous")   icon = "🌖";
    else if (phase == "Last Quarter")     icon = "🌗";
    else if (phase == "Waning Crescent")  icon = "🌘";

    # round illumination
    illump = int(illum + 0.5);

    # print fields (icon|phase|illum%)
    printf("%s|%s|%d%%\n", icon, phase, illump);
  }
  function fmod(a,b) { return a - int(a/b)*b; }
')

icon=${calc%%|*}
rest=${calc#*|}
phase=${rest%%|*}
illum=${calc##*|}

# Minimal text for bar (icon only); detailed tooltip
text="$icon"
# tooltip with real newline (not \n string)
tooltip="Moon phase: $phase
Illumination: $illum"

jq -nc --arg text "$text" --arg tooltip "$tooltip" \
   '{text:$text, tooltip:$tooltip}'
