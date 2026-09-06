{ ... }:
{

  imports = [
    ./base
    ./configuration.nix
    ./flatpak.nix
    ./hardware-configuration.nix
    ./peripherals.nix
    ./graphics.nix
    ../../modules/fonts
    ../../modules/dms
    ../../modules/hyprland
  ];
}
