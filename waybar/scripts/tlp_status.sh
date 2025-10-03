#!/usr/bin/env bash
# tlp_status.sh — Waybar custom module (minimal text, detailed tooltip)

set -euo pipefail
exec 2>/dev/null
export LC_ALL=C

# --- Power source / status ---
power_state="BAT"   # AC | BAT
status="unknown"

# Detect AC
for ps in /sys/class/power_supply/*; do
  [ -r "$ps/type" ] || continue
  if [ "$(cat "$ps/type")" = "Mains" ] && [ -r "$ps/online" ] && [ "$(cat "$ps/online")" = "1" ]; then
    power_state="AC"
    break
  fi
done

# Battery status (we don't show %, just status string)
for ps in /sys/class/power_supply/BAT*; do
  [ -r "$ps/status" ] || continue
  status="$(cat "$ps/status")"
  break
done

# --- CPU governor / EPP / platform profile / driver ---
gov="unknown"; epp=""; plat="n/a"; drv="unknown"
[ -r /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ] && gov="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
[ -r /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference ] && epp="$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference)"
[ -r /sys/firmware/acpi/platform_profile ] && plat="$(cat /sys/firmware/acpi/platform_profile)"
[ -r /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver ] && drv="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver)"

# --- Intel pstate extras (if present) ---
minp=""; maxp=""; noturbo=""; hwpboost=""
[ -r /sys/devices/system/cpu/intel_pstate/min_perf_pct ] && minp="$(cat /sys/devices/system/cpu/intel_pstate/min_perf_pct)"
[ -r /sys/devices/system/cpu/intel_pstate/max_perf_pct ] && maxp="$(cat /sys/devices/system/cpu/intel_pstate/max_perf_pct)"
[ -r /sys/devices/system/cpu/intel_pstate/no_turbo ] && noturbo="$(cat /sys/devices/system/cpu/intel_pstate/no_turbo)"
[ -r /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost ] && hwpboost="$(cat /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost)"

# --- Current freq (cpu0 snapshot) ---
mhz=""
if [ -r /proc/cpuinfo ]; then
  mhz="$(awk -F ': *' '/^cpu MHz/ {print int($2); exit}' /proc/cpuinfo || true)"
fi

# ---------- Minimal text ----------
# Tiny label: just the EPP class (perf/bperf/bpower/power), no battery.
short_epp="$epp"
case "$short_epp" in
  performance) short_epp="perf" ;;
  balance_performance) short_epp="bperf" ;;
  balance_power) short_epp="bpower" ;;
  power|"") short_epp="power" ;;
esac

# keep tiny; you can drop the icon if you want
text="  ${short_epp}"

# ---------- Tooltip (rich, multiline) ----------
readable_power="$([ "$power_state" = "AC" ] && echo "AC" || echo "Battery")"

turbo_str="n/a"
[ -n "$noturbo" ] && turbo_str=$([ "$noturbo" = "0" ] && echo "on" || echo "off")

hwp_str="n/a"
[ -n "$hwpboost" ] && hwp_str=$([ "$hwpboost" = "1" ] && echo "on" || echo "off")

freq_str=""
[ -n "$mhz" ] && freq_str="${mhz} MHz (cpu0)"

ppct=""
if [ -n "$minp" ] || [ -n "$maxp" ]; then
  [ -z "$minp" ] && minp="?"
  [ -z "$maxp" ] && maxp="?"
  ppct="${minp}%..${maxp}%"
fi

tooltip=""
tooltip+=$'Power: '"${readable_power}"$' · Status: '"${status}"$'\n'
tooltip+=$'CPU: gov='"${gov}"$' · EPP='"${epp:-unknown}"$' · driver='"${drv}"$'\n'
tooltip+=$'Platform profile: '"${plat}"$'\n'
[ -n "$ppct" ]   && tooltip+=$'Perf window: '"${ppct}"$'\n'
[ -n "$freq_str" ] && tooltip+=$'Current: '"${freq_str}"$'\n'
tooltip+=$'Turbo: '"${turbo_str}"$' · HWP dynamic boost: '"${hwp_str}"

# ---------- Classes for your CSS ----------
cls="$([ "$power_state" = "AC" ] && echo ac || echo bat)"
perf_class=""
case "$epp" in
  performance) perf_class="perf" ;;
  balance_performance) perf_class="bperf" ;;
  balance_power) perf_class="bpower" ;;
  power) perf_class="power" ;;
esac
classes="$cls"
[ -n "$perf_class" ] && classes="$classes $perf_class"

# ---------- Emit one JSON line ----------
if command -v jq >/dev/null 2>&1; then
  jq -nc --arg text "$text" --arg tooltip "$tooltip" --arg class "$classes" \
    '{text:$text, tooltip:$tooltip, class:$class}'
else
  esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
  t="$(esc "$text")"; tt="$(esc "$tooltip")"; c="$(esc "$classes")"
  printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$t" "$tt" "$c"
fi

