#!/bin/sh
export XDG_RUNTIME_DIR="/tmp/run-$(id -u)"
mkdir -p -m 0700 "$XDG_RUNTIME_DIR"
export LIBSEAT_BACKEND=seatd
export QT_QPA_PLATFORM=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

DWLB_DIR="$HOME/repos/dwlb"

if [ ! -d "$DWLB_DIR" ]; then
    exec dwl
else
    exec dwl -s 'sh -c "$DWLB_DIR/dwlb-status.sh | dwlb -status-stdin all & exec dwlb -status-commands -font \"GohuFont uni11 Nerd Font Mono\""'
fi
