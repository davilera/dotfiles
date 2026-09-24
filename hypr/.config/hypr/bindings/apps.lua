-- Application bindings migrated from bindings/apps.conf.

local terminal = "uwsm app -- kitty"
local browser = "omarchy-launch-browser"

o.bind("SUPER + ALT + B", "Browser", browser)
o.bind("SUPER + ALT + D", "Blender", "blender")
o.bind("SUPER + ALT + F", "File Explorer", "nautilus")
o.bind("SUPER + ALT + G", "ChatGPT", 'firefox-launch-webapp "ChatGPT"')
o.bind("SUPER + ALT + S", "Stats (btop)", "hyprctl dispatch exec '[float;size 1200 800;center] " .. terminal .. " -e btop'")
o.bind("SUPER + ALT + T", "Terminal", terminal .. " --working-directory=$(omarchy-cmd-terminal-cwd)")
o.bind("SUPER + ALT + W", "WhatsApp Web", 'firefox-launch-webapp "WhatsApp"')

-- This binding lived directly in the old bindings.conf.
o.bind("SUPER + ALT + RETURN", "Tmux", 'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux new')
