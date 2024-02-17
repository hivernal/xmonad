#!/bin/bash

if [[ $1 == "up" ]] then
  pactl set-sink-volume @DEFAULT_SINK@ +5%
elif [[ $1 == "down" ]]; then
  pactl set-sink-volume @DEFAULT_SINK@ -5%
elif [[ $1 == "mute" ]]; then
  pactl set-sink-mute @DEFAULT_SINK@ toggle
fi

MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d " "  -f2)
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '(NR == 1) {print $5}')
VOLUME=${VOLUME%%%}
DIR=$HOME/.config/xmonad/icons
if [[ $MUTED == "yes" ]]; then
    ICON=audio-volume-muted-panel.svg
else
  if (( $VOLUME == 0 )); then
    ICON=audio-volume-zero-panel.svg
  elif (( $VOLUME <= 20 )); then
    ICON=audio-volume-low-panel.svg
  elif (( $VOLUME <= 50 )); then
    ICON=audio-volume-medium-panel.svg
  else
    ICON=audio-volume-high-panel.svg
  fi
fi

dunstify -t 2000 -i $DIR/$ICON -h string:x-canonical-private-synchronous:audio "$VOLUME%" -h int:value:$VOLUME
