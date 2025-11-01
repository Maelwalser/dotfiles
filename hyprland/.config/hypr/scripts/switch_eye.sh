#!/bin/bash

# A simple file to track the state.
STATE_FILE="/tmp/hyprlock_eye.lock" 

OPEN_EYE="$HOME/dotfiles/hyprland/.config/hypr/images/eye_open.png"
CLOSED_EYE="$HOME/dotfiles/hyprland/.config/hypr/images/eye_closed.png"

if [ -f "$STATE_FILE" ]; then
    # File exists, so we should show the OPEN eye
    rm "$STATE_FILE"
    echo "$OPEN_EYE"
else
    # File doesn't exist, so we should show the CLOSED eye
    touch "$STATE_FILE"
    echo "$CLOSED_EYE"
fi
