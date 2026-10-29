{ inputs, pkgs, ... }:
{
  imports = [
    inputs.laminix.nixosModules.default
    ../../modules/system/common.nix
    ../../modules/system/fonts

    ./base
    ./configuration.nix
    ./desktop.nix
    ./flatpak.nix
    ./hardware-configuration.nix
    ./peripherals.nix
    ./graphics.nix
  ];

  environment.systemPackages = [
    inputs.butter.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nutmeg
  ];
}
