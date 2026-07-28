{ inputs, ... }:
{

  imports = [
    ./configuration.nix
    ./flatpak.nix
    ./hardware-configuration.nix
    ./peripherals.nix
    inputs.home-manager.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
}
