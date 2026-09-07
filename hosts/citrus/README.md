# Citrus desktop

Umbriel is the default SDDM session and starts Noctalia v5 from its native TOML
configuration. Plasma remains selectable. SDDM replaces Plasma Login Manager
because the latter does not apply NixOS's default-session setting to normal logins.

Rick's editable configuration is `dotfiles/.config/umbriel/config.toml`.
From the repository root, link it with GNU Stow:

```sh
stow --no-folding --ignore='(emacs|fish|kitty)' --dir=. --target="$HOME" dotfiles
```

The ignore list leaves the other existing dotfiles alone. Hjem does not own the
Umbriel configuration. Changes reload live; validate them with `umbriel validate`.

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
| Mod+Q | Close window |
| Mod+Ctrl+L | Lock through Noctalia |
| Mod+V | Clipboard history |
| Mod+N | Control center |
| Mod+Shift+Escape | Session menu |
| Print / Shift+Print | Region / monitor screenshot |
| Volume, media, brightness keys | Noctalia controls and OSD; also work while locked |

Validate and apply on Citrus:

```sh
nix eval .#nixosConfigurations.citrus.config.system.build.toplevel.drvPath
nh os switch . -H citrus
```

Log out and choose Umbriel if SDDM remembers a previously selected session.
The new flake inputs pin Noctalia, Umbriel, and Umbriel's screen-sharing portal;
Umbriel and its portal follow this repository's nixpkgs pin. Noctalia keeps its
upstream nixpkgs pin for compatibility with the Noctalia binary cache.

References: [Umbriel configuration](https://docs.noctalia.dev/umbriel/),
[Noctalia on Umbriel](https://docs.noctalia.dev/noctalia/compositor-settings/umbriel/),
[Noctalia IPC](https://docs.noctalia.dev/noctalia/ipc/overview/).
