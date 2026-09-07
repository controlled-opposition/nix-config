# Citrus desktop

Umbriel is the default SDDM session and starts Noctalia v5 from its native TOML
configuration. Plasma remains selectable. SDDM replaces Plasma Login Manager
because the latter does not apply NixOS's default-session setting to normal logins.

Rick's editable Umbriel and Noctalia v5 configs live under `dotfiles/.config/`.
They follow the examples shipped by the revisions in `flake.lock`, with
Citrus app bindings and launcher pins added. Unspecified settings inherit the
built-in defaults.

| File under `dotfiles/.config/` | Purpose |
| --- | --- |
| `umbriel/config.toml` | Entry point and ordered includes |
| `umbriel/settings.toml` | Session startup, input, appearance, scrolling layout |
| `umbriel/keybinds.toml` | Packaged compositor shortcuts |
| `umbriel/apps.toml` | Shortcuts for Citrus apps |
| `umbriel/noctalia.toml` | Shell panels, lock, screenshots, hardware controls |
| `umbriel/rules.toml` | Packaged window and layer rules, including PiP and Steam toasts |
| `noctalia/bar.toml` | Default top bar and widgets; dock disabled by default |
| `noctalia/launcher.toml` | Default launcher behavior and Citrus app pins |
| `noctalia/theme.toml` | Default Noctalia dark palette |

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
