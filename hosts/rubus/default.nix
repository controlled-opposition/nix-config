{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-wsl.nixosModules.default

    ../../modules/system/common.nix
    ../../home/weasel

    ./configuration.nix
  ];
}
