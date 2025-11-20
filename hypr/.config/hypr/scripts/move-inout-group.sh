#!/usr/bin/env bash

in_group=$(hyprctl -j activewindow | jq 'has("grouped") and (.grouped | length > 0)')

if [[ "$in_group" = "true" ]]; then
  hyprctl dispatch moveoutofgroup
else
  hyprctl dispatch moveintogroup l
fi
