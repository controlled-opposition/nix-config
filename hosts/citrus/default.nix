{ inputs, ... }:
{
  imports = [
    inputs.determinate.nixosModules.default
    inputs.laminix.nixosModules.default
    inputs.bootvine.nixosModules.default
    inputs.flyline.nixosModules.default
    ../../modules/system/common.nix
    ../../modules/system/fonts

    ./bootloader.nix
    ./configuration.nix
    ./desktop.nix
    ./flatpak.nix
    ./gaming.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./peripherals.nix
    ./users.nix
  ];
}
