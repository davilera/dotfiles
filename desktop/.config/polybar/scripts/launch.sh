#!/usr/bin/env bash

# Terminate already running bar instances
polybar-msg cmd quit

# Launch the bar
polybar -q main &
