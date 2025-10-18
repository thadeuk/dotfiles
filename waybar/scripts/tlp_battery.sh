#!/usr/bin/env bash
# tlp_battery.sh — Waybar custom battery w/ TLP tooltip
set -euo pipefail
exec 2>/dev/null
export LC_ALL=C

# ---------- Detect AC ----------
power_state="BAT" # AC|BAT
for ps in /sys/class/power_supply/*; do
  [ -r "$ps/type" ] || continue
  if [ "$(cat "$ps/type")" = "Mains" ] && [ -r "$ps/online" ] && [ "$(cat "$ps/online")" = "1" ]; then
    power_state="AC"
    break
  fi
done

# ---------- Battery aggregate (supports multi-battery) ----------
sum_now=0 sum_full=0 sum_power=0 avg_voltage=0 have_energy=0 use_charge=0 cap_any=""
status="Unknown"
for ps in /sys/class/power_supply/BAT*; do
  [ -d "$ps" ] || continue
  [ -r "$ps/status" ] && status="$(cat "$ps/status")"
  if [ -r "$ps/energy_now" ] && [ -r "$ps/energy_full" ]; then
    have_energy=1
    now=$(cat "$ps/energy_now")
    full=$(cat "$ps/energy_full")
    sum_now=$((sum_now + now))
    sum_full=$((sum_full + full))
    [ -r "$ps/power_now" ] && sum_power=$((sum_power + $(cat "$ps/power_now")))
  elif [ -r "$ps/charge_now" ] && [ -r "$ps/charge_full" ]; then
    have_energy=1
    use_charge=1
    now=$(cat "$ps/charge_now")
    full=$(cat "$ps/charge_full")
    sum_now=$((sum_now + now))
    sum_full=$((sum_full + full))
    if [ -r "$ps/current_now" ] && [ -r "$ps/voltage_now" ]; then
      current=$(cat "$ps/current_now")
      voltage=$(cat "$ps/voltage_now")
      avg_voltage=$voltage
      sum_power=$((sum_power + current))
    fi
  elif [ -r "$ps/capacity" ]; then
    [ -z "${cap_any:-}" ] && cap_any="$(cat "$ps/capacity")"
  fi
done

if [ "$have_energy" = "1" ] && [ "$sum_full" -gt 0 ]; then
  capacity=$(( (sum_now * 100) / sum_full ))
elif [ -n "${cap_any:-}" ]; then
  capacity=$cap_any
else
  capacity=0
fi

time_remaining=""
if [ "$sum_power" -gt 0 ]; then
  if [ "$status" = "Discharging" ]; then
    hours_raw=$(awk "BEGIN {printf \"%.2f\", $sum_now / $sum_power}")
  elif [ "$status" = "Charging" ]; then
    remaining=$((sum_full - sum_now))
    hours_raw=$(awk "BEGIN {printf \"%.2f\", $remaining / $sum_power}")
  fi
  if [ -n "${hours_raw:-}" ] && [ "$(awk "BEGIN {print ($hours_raw > 0)}")" = "1" ]; then
    hours=$(awk "BEGIN {print int($hours_raw)}")
    mins=$(awk "BEGIN {print int(($hours_raw - $hours) * 60)}")
    if [ "$status" = "Discharging" ]; then
      time_remaining="${hours}h ${mins}m remaining"
    elif [ "$status" = "Charging" ]; then
      time_remaining="${hours}h ${mins}m until full"
    fi
  fi
fi

# ---------- CPU / platform bits for tooltip ----------
gov="unknown"; epp=""; plat="n/a"; drv="unknown"
[ -r /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ] && gov="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
[ -r /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference ] && epp="$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference)"
[ -r /sys/firmware/acpi/platform_profile ] && plat="$(cat /sys/firmware/acpi/platform_profile)"
[ -r /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver ] && drv="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver)"

minp=""; maxp=""; noturbo=""; hwpboost=""
[ -r /sys/devices/system/cpu/intel_pstate/min_perf_pct ] && minp="$(cat /sys/devices/system/cpu/intel_pstate/min_perf_pct)"
[ -r /sys/devices/system/cpu/intel_pstate/max_perf_pct ] && maxp="$(cat /sys/devices/system/cpu/intel_pstate/max_perf_pct)"
[ -r /sys/devices/system/cpu/intel_pstate/no_turbo ] && noturbo="$(cat /sys/devices/system/cpu/intel_pstate/no_turbo)"
[ -r /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost ] && hwpboost="$(cat /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost)"

mhz=""
if [ -r /proc/cpuinfo ]; then
  mhz="$(awk -F ': *' '/^cpu MHz/ {print int($2); exit}' /proc/cpuinfo || true)"
fi

short_epp="$epp"
case "$short_epp" in
  performance) short_epp="perf" ;;
  balance_performance) short_epp="bperf" ;;
  balance_power) short_epp="bpower" ;;
  power|"") short_epp="power" ;;
esac

turbo_str="n/a"; [ -n "$noturbo" ] && turbo_str=$([ "$noturbo" = "0" ] && echo "on" || echo "off")
hwp_str="n/a";   [ -n "$hwpboost" ] && hwp_str=$([ "$hwpboost" = "1" ] && echo "on" || echo "off")
freq_str="";     [ -n "$mhz" ] && freq_str="${mhz} MHz (cpu0)"
ppct="";         { [ -n "$minp" ] || [ -n "$maxp" ]; } && ppct="${minp:-?}%..${maxp:-?}%"

readable_power=$([ "$power_state" = "AC" ] && echo "AC" || echo "Battery")

tooltip=""
tooltip+=$'Power: '"${readable_power}"$' · Status: '"${status}"
[ -n "$time_remaining" ] && tooltip+=$' · '"${time_remaining}"
tooltip+=$'\n'
tooltip+=$'CPU: gov='"${gov}"$' · EPP='"${epp:-unknown}"$' · driver='"${drv}"$'\n'
tooltip+=$'Platform profile: '"${plat}"$'\n'
[ -n "$ppct" ]   && tooltip+=$'Perf window: '"${ppct}"$'\n'
[ -n "$freq_str" ] && tooltip+=$'Current: '"${freq_str}"$'\n'
tooltip+=$'Turbo: '"${turbo_str}"$' · HWP dynamic boost: '"${hwp_str}"$'\n'
# Optional: append one-line TLP summary (fast, no sudo)
if command -v tlp-stat >/dev/null 2>&1; then
  tlps="$(tlp-stat -s 2>/dev/null | sed -n '1,6p' | tr -d '\r')"
  [ -n "$tlps" ] && tooltip+=$'\n'"${tlps}"
fi

# ---------- Text & icon like Waybar battery ----------
# Icons from your config
icons=( "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" )
idx=$(( capacity / 10 ))
[ $idx -lt 0 ] && idx=0
[ $idx -gt 10 ] && idx=10
icon="${icons[$idx]}"
if [ "$power_state" = "AC" ] || [ "$status" = "Charging" ]; then
  icon=""
fi
text="${icon} ${capacity}%"

# ---------- Classes ----------
classes="$([ "$power_state" = "AC" ] && echo ac || echo bat)"
case "$short_epp" in
  perf|bperf|bpower|power) classes="$classes $short_epp" ;;
esac
case "$status" in
  Charging) classes="$classes charging" ;;
  Discharging) classes="$classes discharging" ;;
  Full) classes="$classes full" ;;
esac

# ---------- Emit JSON ----------
if command -v jq >/dev/null 2>&1; then
  jq -nc --arg text "$text" --arg tooltip "$tooltip" --arg class "$classes" \
    '{text:$text, tooltip:$tooltip, class:$class}'
else
  esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
  printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$(esc "$text")" "$(esc "$tooltip")" "$(esc "$classes")"
fi

