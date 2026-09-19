{ inputs, ... }:
{
  imports = [
    inputs.hjem.nixosModules.default
    inputs.nixos-wsl.nixosModules.default

    ../../modules/system/common.nix
    ../../home/weasel

    ./configuration.nix
  ];
}
