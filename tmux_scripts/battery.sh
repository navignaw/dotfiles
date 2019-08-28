#!/bin/bash

status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
if [[ $status =~ 'discharging' ]]; then
  symbol='♥'
else
  symbol='⚡'
fi
echo "$symbol$(echo $status | grep -o 'percentage: [0-9]*\%' | cut -f2- -d:)"
