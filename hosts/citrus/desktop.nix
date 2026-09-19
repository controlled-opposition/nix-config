{ inputs, ... }:
{
  imports = [
    inputs.umbriel.nixosModules.default
    ../../modules/nixos/noctalia
  ];

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  programs.hyprland.enable = true;
  programs.umbriel.enable = true;
}
