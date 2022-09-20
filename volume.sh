#!/bin/bash
VOLUME=$(pamixer --get-volume)
if [[ $VOLUME -le 10 ]]; then
  echo "奄"
elif [[ $VOLUME -le 40 ]]; then
  echo "奔"
else
  echo "墳"
fi
