{ pkgs, ... }:
let
  settings = {
    shell = {
      font_family = "sans-serif";
      settings_show_advanced = true;
      polkit_agent = false;
    };

    theme = {
      mode = "dark";
      source = "builtin";
      builtin = "Catppuccin";
    };

    wallpaper = {
      enabled = true;
      fill_mode = "crop";
      directory = "${../../wallpapers}";
      default.path = "${../../wallpapers/wallhaven-qr3mk7.png}";
    };

    backdrop = {
      enabled = true;
      blur_intensity = 0.5;
      tint_intensity = 0.3;
    };

    brightness.enable_ddcutil = true;
  };
in
{
  # The NixOS module owns the package and service. Hjem owns the user's
  # generated settings file.
  xdg.config.files."noctalia/config.toml" = {
    source = (pkgs.formats.toml { }).generate "noctalia-config.toml" settings;
    clobber = true;
  };
}
