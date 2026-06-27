#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

CPU=$(top -l 2 -n 0 -F | awk '/^CPU/ {print $3}' | tail -1 | cut -d. -f1)

RAM=$(memory_pressure | awk '/System-wide memory free percentage:/ {print 100-$5}')

sketchybar --set $NAME label="cpu:${CPU}% ram:${RAM}%"
