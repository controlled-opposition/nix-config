{ inputs, ... }:
{

  imports = [
    ./configuration.nix
    ./flatpak.nix
    ./hardware-configuration.nix
    ./peripherals.nix
    ./boot.nix
    ./network.nix
    ./users.nix
    ./settings.nix
    ./graphics.nix
    ../../modules/niri
    ../../modules/noctalia
    inputs.home-manager.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
}
