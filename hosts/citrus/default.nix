{ inputs, ... }:
{
  imports = [
    inputs.chaotic.nixosModules.default
    inputs.home-manager.nixosModules.home-manager

    ../../modules/system/common.nix
    ../../modules/system/cache
    ../../modules/system/emacs
    ../../modules/system/fonts
    ../../home/rick

    ./base
    ./configuration.nix
    ./desktop.nix
    ./flatpak.nix
    ./hardware-configuration.nix
    ./peripherals.nix
    ./graphics.nix
  ];
}
