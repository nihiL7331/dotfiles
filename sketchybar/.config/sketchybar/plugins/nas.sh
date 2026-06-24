#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

TARGET="server" 

if ping -c 1 -W 1 "$TARGET" >/dev/null 2>&1; then
  sketchybar --set $NAME icon.color=$GREEN label.color=$FG label="up"
else
  sketchybar --set $NAME icon.color=$RED label.color=$RED label="down"
fi
