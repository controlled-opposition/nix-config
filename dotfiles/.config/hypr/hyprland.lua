-- Rick / Citrus. Link with GNU Stow; see hosts/citrus/README.md.
-- Native Lua API for the pinned Hyprland 0.56.2.
-- https://wiki.hypr.land/Configuring/Start/

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.monitor({ output = "DP-1", mode = "2560x1440@360", position = "auto", scale = 1 })
hl.env("TERMINAL", "kitty")
hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
end)

hl.config({
  general = { layout = "dwindle", gaps_in = 2, gaps_out = 4, border_size = 2 },
  dwindle = { preserve_split = true },
  decoration = { rounding = 10, blur = { enabled = true } },
  input = {
    kb_layout = "us",
    repeat_rate = 25,
    repeat_delay = 600,
    accel_profile = "flat",
    sensitivity = 0,
    touchpad = { tap_to_click = true },
  },
  misc = { disable_hyprland_logo = true, force_default_wallpaper = 0 },
})

local mod = "SUPER"
local function bind(key, action, options)
  hl.bind(mod .. " + " .. key, action, options or {})
end
local function shell(key, command)
  bind(key, hl.dsp.exec_cmd(command))
end

bind("Q", hl.dsp.window.close())
bind("T", hl.dsp.window.float({ action = "toggle" }))
bind("SHIFT + T", hl.dsp.window.cycle_next({ floating = true }))
bind("P", hl.dsp.window.pin({ action = "toggle" }))
bind("F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
bind("M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

for key, direction in pairs({
  H = "left", J = "down", K = "up", L = "right",
  Left = "left", Down = "down", Up = "up", Right = "right",
}) do
  bind(key, hl.dsp.focus({ direction = direction }))
  bind("SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end
for i = 1, 9 do
  bind(tostring(i), hl.dsp.focus({ workspace = i }))
  bind("SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- A special workspace serves as the scratchpad; restore its focused window.
bind("S", hl.dsp.workspace.toggle_special("scratchpad"))
bind("SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
bind("CTRL + S", hl.dsp.window.move({ workspace = "m+0" }))
bind("Tab", hl.dsp.window.cycle_next())

-- Dwindle resizing in 40-pixel steps instead of scrolling width/height presets.
bind("R", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
bind("SHIFT + R", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
bind("ALT + R", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })
bind("ALT + SHIFT + R", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
bind("mouse_up", hl.dsp.focus({ direction = "left" }))
bind("mouse_down", hl.dsp.focus({ direction = "right" }))
bind("SHIFT + mouse_up", hl.dsp.window.move({ direction = "left" }))
bind("SHIFT + mouse_down", hl.dsp.window.move({ direction = "right" }))
bind("mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

shell("Return", "kitty")
shell("E", "dolphin")
shell("B", "helium")
for key, command in pairs({
  D = "panel-toggle launcher",
  N = "panel-toggle control-center",
  V = "panel-toggle clipboard",
  ["CTRL + L"] = "session lock",
  Escape = "panel-toggle session",
  comma = "settings-toggle",
  -- Noctalia's window switcher is the overview alternative.
  O = "window-switcher",
}) do
  shell(key, "noctalia msg " .. command)
end
hl.bind("ALT + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher"))
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))

for key, command in pairs({
  XF86AudioRaiseVolume = "volume-up",
  XF86AudioLowerVolume = "volume-down",
  XF86MonBrightnessUp = "brightness-up",
  XF86MonBrightnessDown = "brightness-down",
}) do
  hl.bind(key, hl.dsp.exec_cmd("noctalia msg " .. command), { locked = true, repeating = true })
end
for key, command in pairs({
  XF86AudioMute = "volume-mute",
  XF86AudioMicMute = "mic-mute",
  XF86AudioPlay = "media toggle",
  XF86AudioPause = "media pause",
  XF86AudioNext = "media next",
  XF86AudioPrev = "media previous",
}) do
  hl.bind(key, hl.dsp.exec_cmd("noctalia msg " .. command), { locked = true })
end

hl.window_rule({
  name = "noctalia-settings",
  match = { class = "^dev.noctalia.Noctalia$" },
  float = true,
  size = "1020 900",
})
hl.window_rule({
  name = "picture-in-picture",
  match = { title = "^(Picture-in-Picture|Picture in picture)$" },
  float = true,
  pin = true,
})
hl.layer_rule({
  name = "noctalia-blur",
  match = { namespace = "^noctalia-(bar-.*|notification|dock|panel|attached-panel|osd|desktop-widget-.*)$" },
  blur = true,
  ignore_alpha = 0.5,
})
