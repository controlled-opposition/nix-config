# Citrus desktop

Hyprland and Plasma are selectable SDDM sessions. Hyprland starts Noctalia v5
from its native Lua configuration. No default session is forced. The Umbriel
configuration remains available in the repository, but its desktop module is
currently not imported by Citrus.

Rick's Hyprland config is `dotfiles/.config/hypr/hyprland.lua`, managed with the
same Stow command below. It uses the native Lua API in the pinned Hyprland
0.56.2; no input pin changes are needed. It matches Umbriel's current Dwindle
layout, DP-1 mode, input settings, app shortcuts, Noctalia controls, and hardware
keys. Super is the modifier, including when running nested.

Hyprland-specific equivalents:

| Shortcut | Action |
| --- | --- |
| Super+H/J/K/L or arrows | Focus; add Shift to move the window |
| Super+1–9 / Super+Shift+1–9 | Switch workspace / move window |
| Super+T / Super+Shift+T | Toggle floating / cycle floating windows |
| Super+F / M / P | Toggle fullscreen / maximize / pin floating window |
| Super+S / Super+Shift+S | Toggle scratchpad / send window there |
| Super+Ctrl+S | Restore focused scratchpad window to the monitor's normal workspace |
| Super+Tab | Cycle windows in the current workspace (including the open scratchpad) |
| Super+R / Super+Shift+R | Grow / shrink width by 40 pixels |
| Super+Alt+R / Super+Alt+Shift+R | Grow / shrink height by 40 pixels |
| Super+O / Alt+Tab | Noctalia window switcher |
| Super+Escape / Super+Comma | Noctalia session menu / settings |
| Super+left/right mouse drag | Move / resize window |

The scratchpad uses a Hyprland special workspace. Open it and focus a window
before restoring it. Width/height presets and Umbriel's overview have the
equivalents above. The Lua file follows the current Umbriel keybind file;
the older Umbriel shortcut summary below may differ from local edits.

Validate Hyprland without starting a session:

```sh
Hyprland --verify-config -c "$PWD/dotfiles/.config/hypr/hyprland.lua"
```

After Stow and rebuilding Citrus with the command below, log out and select
Hyprland in SDDM. Configuration edits reload automatically; startup commands
and environment changes require a new session.

References: [Hyprland Lua configuration](https://wiki.hypr.land/Configuring/Start/),
[Hyprland 0.56.2 example](https://github.com/hyprwm/Hyprland/blob/v0.56.2/example/hyprland.lua).

Rick's editable Umbriel and Noctalia v5 configs live under `dotfiles/.config/`.
They follow the examples shipped by the revisions in `flake.lock`, with
Citrus app bindings and launcher pins added. Unspecified settings inherit the
built-in defaults.

| File under `dotfiles/.config/` | Purpose |
| --- | --- |
| `umbriel/config.toml` | Ordered includes, general session settings, and environment |
| `umbriel/outputs.toml` | Output settings, including the Citrus DP-1 monitor mode |
| `umbriel/keybinds.toml` | Compositor, Citrus app, and Noctalia shortcuts |
| `umbriel/input.toml` | Keyboard, touchpad, mouse, and other input settings |
| `umbriel/appearance.toml` | Colors and window appearance; unspecified colors use defaults |
| `umbriel/layout.toml` | Layout selection and scrolling settings |
| `umbriel/window-rules.toml` | Window rules, including PiP and Steam toasts |
| `umbriel/layer-rules.toml` | Noctalia layer rules and blur |
| `noctalia/bar.toml` | Default top bar and widgets |
| `noctalia/dock.toml` | App dock settings; disabled by default |
| `noctalia/launcher.toml` | Default launcher behavior and Citrus app pins |
| `noctalia/theme.toml` | Default Noctalia dark palette |
| `noctalia/app-theming.toml` | App theme template selection; templates remain opt-in |

Both configurations follow their documentation sections. Umbriel groups all
keybinds in one file and keeps window rules in their matching order.
Umbriel loads the files listed in `config.toml`; Noctalia automatically merges
all top-level `*.toml` files alphabetically. No generation step is needed.
From the repository root on Citrus, link both configurations with GNU Stow:

```sh
stow --no-folding --ignore='(emacs|fish|kitty)' --dir=. --target="$HOME" dotfiles
```

The ignore list leaves the other existing dotfiles alone. Hjem does not own
these configuration files. Re-run Stow after adding a file. Changes reload live,
except startup settings such as Umbriel's environment and autostart commands.

Noctalia's GUI saves overrides in `~/.local/state/noctalia/settings.toml`,
which takes precedence over these files. If an old GUI setting still appears,
inspect that file and remove the corresponding override, or back it up and move
it aside to reset all GUI overrides.

The launcher pins Kitty, Dolphin, Helium, Firefox, Chrome, VS Code, Zed, Obsidian,
Discord, Spotify, Steam, Faugus Launcher, Sober, Gopeed, and btop. These are
installed by `hosts/citrus/` and `home/rick/`; other apps remain searchable
automatically. Pins use desktop entry IDs without the `.desktop` suffix.
`TERMINAL=kitty` makes terminal entries such as btop open in Kitty.

`Mod` is Super in a native session and Alt when nested. Umbriel's built-in
navigation stays intact: H/J/K/L or arrows focus windows, Shift moves them,
1–9 selects workspaces, Shift+1–9 moves windows, R cycles width, F toggles
fullscreen, O opens the overview, T toggles floating, and Escape confirms logout.
The packaged Space/Shift+Space/Ctrl+Space/Tab scratchpad shortcuts are preserved.

| Shortcut | Action |
| --- | --- |
| Mod alone or Mod+D | Noctalia launcher |
| Mod+Return | Kitty |
| Mod+Shift+Return | btop in Kitty |
| Mod+E | Dolphin |
| Mod+B | Helium |
| Mod+Ctrl+B / C | Firefox / Chrome |
| Mod+Ctrl+E / Z | VS Code / Zed |
| Mod+Ctrl+D / O / S | Discord / Obsidian / Spotify |
| Mod+Ctrl+G | Steam |
| Mod+Ctrl+Shift+G / S | Faugus Launcher / Sober |
| Mod+Ctrl+J | Gopeed |
| Mod+Q | Close window |
| Mod+Ctrl+L | Lock through Noctalia |
| Mod+V | Clipboard history |
| Mod+N | Control center |
| Mod+Shift+Escape | Session menu |
| Mod+Ctrl+Comma | Noctalia settings |
| Alt+Tab | Noctalia window switcher |
| Print / Shift+Print | Region / monitor screenshot |
| Volume, media, brightness keys | Noctalia controls and OSD; also work while locked |

Validate the dotfiles directly on Citrus, before linking them if desired:

```sh
umbriel validate -c dotfiles/.config/umbriel/config.toml
noctalia config validate dotfiles/.config/noctalia
```

After linking, `umbriel validate` and `noctalia config validate` check the
active config locations, including Noctalia's GUI overrides.

Evaluate the system without activation; rebuild on Citrus when system packages
or modules change:

```sh
nix eval .#nixosConfigurations.citrus.config.system.build.toplevel.drvPath
nh os switch . -H citrus
```

Log out and choose Umbriel if SDDM remembers a previously selected session.
The flake inputs pin Noctalia, Umbriel, and Umbriel's screen-sharing portal;
Umbriel and its portal follow this repository's nixpkgs pin. Noctalia keeps its
upstream nixpkgs pin for compatibility with the Noctalia binary cache.

References: [Umbriel configuration](https://docs.noctalia.dev/umbriel/),
[Umbriel starting config](https://github.com/noctalia-dev/umbriel/blob/7a448abe550ecbebba7f0ae90e4d96a820fc592e/examples/config.toml),
[Noctalia defaults](https://github.com/noctalia-dev/noctalia/blob/830ce58c9da58853166ffd8a6a1497c5d4b47a6b/example.toml),
[Noctalia configuration](https://docs.noctalia.dev/noctalia/configuration/),
[Noctalia on Umbriel](https://docs.noctalia.dev/noctalia/compositor-settings/umbriel/),
[Noctalia IPC](https://docs.noctalia.dev/noctalia/ipc/overview/).
