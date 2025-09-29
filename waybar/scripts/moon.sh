#!/bin/bash
# Requires 'curl' and 'jq'
phase=$(curl -s "https://api.farmsense.net/v1/moonphases/?d=$(date +%s)" | jq -r '.[0].Phase')
icon="🌑"
case $phase in
  "First Quarter") icon="🌓" ;;
  "Full Moon") icon="🌕" ;;
  "Last Quarter") icon="🌗" ;;
  "New Moon") icon="🌑" ;;
  "Waxing Crescent") icon="🌒" ;;
  "Waxing Gibbous") icon="🌔" ;;
  "Waning Gibbous") icon="🌖" ;;
  "Waning Crescent") icon="🌘" ;;
esac
echo "$icon $phase"
