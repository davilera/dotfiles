#!/usr/bin/env bash

# Terminate already running bar instances
polybar-msg cmd quit

# Launch bar1 and bar2
polybar main 2>&1 >/dev/null # | tee -a /tmp/polybar-main.log & disown
