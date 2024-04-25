#!/usr/bin/env bash

# Install this:
# https://github.com/erebe/greenclip

DIR="$HOME/.config/rofi"

rofi -no-config -no-lazy-grab -show clipboard -modi "clipboard:greenclip print" -run-command '{cmd}' -theme $DIR/clipboard.rasi
