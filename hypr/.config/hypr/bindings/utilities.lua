-- Utility bindings migrated from bindings/utilities.conf.

-- Clipboard
o.bind("SUPER + C", "Clipboard history", "omarchy launch walker -m clipboard")
o.bind("SUPER + SHIFT + C", "Calculator", "omarchy launch walker -m calc")

-- Menus
o.bind("SUPER + M", "Launch apps", 'omarchy launch walker -p "Launch…"')
o.bind("SUPER + APOSTROPHE", "Emoji picker", "omarchy launch walker -m symbols")
o.bind("SUPER + A", "Omarchy menu", "omarchy menu")
o.bind("SUPER + ESCAPE", "Power menu", "omarchy menu system")
o.bind("SUPER + SHIFT + SLASH", nil, "omarchy menu keybindings")

-- Nightlight
o.bind("SUPER + N", "Toggle nightlight", "omarchy toggle nightlight")

-- Screenshots / recordings
o.bind("SUPER + P", "Screenshot of region", "omarchy capture screenshot")
o.bind("SUPER + SHIFT + P", "Screenshot of display", "omarchy capture screenshot fullscreen")
o.bind("SUPER + V", "Screen record a region", "omarchy capture screenrecording")

-- Color picker
o.bind("SUPER + D", "Dropper tool (color picker)", "pkill hyprpicker || hyprpicker -a")
