# Configure the Citrus desktop

Run these commands from the repository root on Citrus.

1. Validate the dotfiles:

   ```sh
   Hyprland --verify-config -c "$PWD/dotfiles/.config/hypr/hyprland.lua"
   umbriel validate -c dotfiles/.config/umbriel/config.toml
   noctalia config validate dotfiles/.config/noctalia
   ```

2. Fix any validation errors. [Link the dotfiles](../../README.md#link-dotfiles).
3. If system packages or modules changed, [check and rebuild Citrus](../../README.md#check-changes).
4. Start a Hyprland, Umbriel, or Plasma session in SDDM.

To change shortcuts, edit [`hyprland.lua`](../../dotfiles/.config/hypr/hyprland.lua) or [`umbriel/keybinds.toml`](../../dotfiles/.config/umbriel/keybinds.toml).
After changing startup commands or environment settings, start a new session.

## Fix Noctalia overrides

If a repository setting has no effect, check `~/.local/state/noctalia/settings.toml` for a GUI override.
Back up that file before removing overrides. Validate the active configuration with `noctalia config validate`.
