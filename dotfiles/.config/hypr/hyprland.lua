-- Hyprland configuration for Rick.

local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "dolphin"
local launcher = "dms ipc call spotlight toggle"

-- Use the preferred mode on every connected output and let Hyprland place it.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
    col = {
      active_border = {
        colors = { "rgba(c4a7e7ee)", "rgba(31748fee)" },
        angle = 45,
      },
      inactive_border = "rgba(403d52aa)",
    },
  },

  decoration = {
    rounding = 10,
    active_opacity = 1.0,
    inactive_opacity = 0.95,
    fullscreen_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0xee191724,
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 2,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },

  input = {
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
    },
    accel_profile = "flat",
    force_no_accel = true, 
  },
})

hl.curve("easeOutQuint", {
  type = "bezier",
  points = { { 0.23, 1 }, { 0.32, 1 } },
})
hl.curve("easeInOutCubic", {
  type = "bezier",
  points = { { 0.65, 0.05 }, { 0.36, 1 } },
})

hl.animation({
  leaf = "windows",
  enabled = true,
  speed = 5,
  bezier = "easeOutQuint",
})
hl.animation({
  leaf = "windowsOut",
  enabled = true,
  speed = 5,
  bezier = "easeInOutCubic",
  style = "popin 80%",
})
hl.animation({
  leaf = "border",
  enabled = true,
  speed = 4,
  bezier = "easeOutQuint",
})
hl.animation({
  leaf = "fade",
  enabled = true,
  speed = 5,
  bezier = "easeOutQuint",
})
hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = 5,
  bezier = "easeOutQuint",
  style = "slide",
})

-- Applications and desktop shell.
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("dms ipc call bar toggle"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("dms ipc call dash toggle"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("dms screenshot"))

-- Window management.
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Workspaces 1 through 10.
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse movement and resizing.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys are handled by DankMaterialShell's IPC interface.
local lockedRepeating = { locked = true, repeating = true }
local locked = { locked = true }

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment"), lockedRepeating)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement"), lockedRepeating)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), locked)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc call mpris playPause"), locked)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc call mpris next"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc call mpris previous"), locked)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("dms ipc call brightness increment"), lockedRepeating)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("dms ipc call brightness decrement"), lockedRepeating)

-- DMS Include Configs
require("dms.outputs")
