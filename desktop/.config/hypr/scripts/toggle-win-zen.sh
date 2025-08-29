#!/usr/bin/env bash

MAXW="1600"

read -r Y H ADDR < <(hyprctl -j activewindow | jq -r '"\(.at[1]) \(.size[1]) \(.address)"')

# active monitor info
read -r MONX MONW < <(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | "\(.x) \(.width)"')

# clamp width
NEWX=$((MONX + (MONW - MAXW) / 2))
hyprctl --batch "dispatch togglefloating ; dispatch resizeactive exact \"$MAXW\" \"$H\" ; dispatch centerwindow"
hyprctl dispatch movewindowpixel exact "$NEWX" "$Y",address:"$ADDR"
