-- Tiling/window-management bindings migrated from bindings/tiling.conf.

-- Close windows
o.bind("SUPER + SHIFT + X", "Close active window", hl.dsp.window.close())

-- Control tiling
o.bind("SUPER + F", "Toggle full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + SLASH", "Toggle split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + Z", "Toggle zen mode", hl.dsp.window.pseudo())
-- Preserve the old dispatcher behavior exactly (the old descriptions and
-- cyclenext direction were opposite of what their names suggest).
o.bind("SUPER + S", "Cycle next", hl.dsp.window.cycle_next({ next = false }))
o.bind("SUPER + SHIFT + S", "Cycle previous", hl.dsp.window.cycle_next())

-- Groups
o.bind("SUPER + G", "Toggle group", hl.dsp.group.toggle())
o.bind("SUPER + SHIFT + G", "Toggle window into and out of group on left", "~/.config/hypr/scripts/move-inout-group.sh")
o.bind("SUPER + COMMA", "Next window in group", "hyprctl dispatch changegroupactive b")
o.bind("SUPER + PERIOD", "Previous window in group", "hyprctl dispatch changegroupactive f")
o.bind("SUPER + SHIFT + COMMA", "Swap window to the left in group", "hyprctl dispatch movegroupwindow b")
o.bind("SUPER + SHIFT + PERIOD", "Swap window to the right in group", "hyprctl dispatch movegroupwindow f")

-- Resize active window
o.bind("SUPER + LEFT", "Adjust divider left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + RIGHT", "Adjust divider right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind("SUPER + UP", "Adjust divider upwards", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + DOWN", "Adjust divider downwards", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

-- Move focus with SUPER + H/J/K/L
o.bind("SUPER + H", "Move focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Move focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Move focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Move focus right", hl.dsp.focus({ direction = "r" }))

-- Swap active window with the one next to it
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- Workspace bindings: preserve both the QWERTY row and number-row shortcuts.
local workspace_keys = { "Q", "W", "E", "R", "T", "Y", "U", "I", "O" }
for workspace = 1, 9 do
  local number = tostring(workspace)
  local letter = workspace_keys[workspace]
  o.bind("SUPER + " .. letter, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = number }))
  o.bind("SUPER + " .. number, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = number }))
  o.bind("SUPER + SHIFT + " .. letter, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = number }))
  o.bind("SUPER + SHIFT + " .. number, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = number }))
end

-- Scroll through existing workspaces
o.bind("SUPER + mouse_down", "Scroll active workspace forward", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + mouse_up", "Scroll active workspace backward", hl.dsp.focus({ workspace = "e-1" }))

-- Drag windows with LMB and resize windows with RMB
o.bind("SUPER + mouse:272", "Move window", hl.dsp.window.drag(), { mouse = true })
o.bind("SUPER + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })
