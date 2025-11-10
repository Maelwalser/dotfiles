#!/bin/bash

# A simple file to track the state.
STATE_FILE="/tmp/hyprlock_bonga.lock" 

BONGA_UP="$HOME/dotfiles/hyprland/.config/hypr/images/bonga_up.png"
BONGA_DOWN="$HOME/dotfiles/hyprland/.config/hypr/images/bonga_down.png"

if [ -f "$STATE_FILE" ]; then
rm "$STATE_FILE"
echo "$BONGA_DOWN"
else
# File doesn't exist, so we should show the CLOSED eye
touch "$STATE_FILE"
echo "$BONGA_UP"
fi
