{ inputs, ... }:
{
  imports = [
    inputs.umbriel.nixosModules.default
    inputs.noctalia.nixosModules.default
  ];

  programs.umbriel.enable = true;
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    # Started by Umbriel's native TOML configuration.
    systemd.enable = false;
  };

  services.displayManager.defaultSession = "umbriel";

  # Keep DMS available for the existing Hyprland session only.
  programs.dms-shell.systemd.target = "wayland-session@hyprland.desktop.target";
  systemd.user.services.dms = {
    partOf = [ "wayland-session@hyprland.desktop.target" ];
    after = [ "wayland-session@hyprland.desktop.target" ];
  };
}
