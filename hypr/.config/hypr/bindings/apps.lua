-- Application bindings migrated from bindings/apps.conf.

o.bind("SUPER + ALT + B", "Blender", "blender")
o.bind("SUPER + ALT + E", "File explorer", { omarchy = "nautilus" })
o.bind("SUPER + ALT + F", "Firefox", { omarchy = "browser" })
o.bind("SUPER + ALT + S", "Stats (btop)", { tui = "btop" })
o.bind("SUPER + ALT + T", "Terminal", { omarchy = "terminal" })
o.bind("SUPER + ALT + W", "WhatsApp Web", 'firefox-launch-webapp "WhatsApp"')

-- This binding lived directly in the old bindings.conf.
o.bind("SUPER + ALT + RETURN", "Tmux", 'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux new')
