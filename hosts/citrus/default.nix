{ inputs, ... }:
{
  imports = [
    inputs.chaotic.nixosModules.default

    ../../modules/system/common.nix
    ../../modules/system/cache
    ../../modules/system/emacs
    ../../modules/system/fonts

    ./base
    ./configuration.nix
    ./desktop.nix
    ./flatpak.nix
    ./hardware-configuration.nix
    ./peripherals.nix
    ./graphics.nix
  ];
}
