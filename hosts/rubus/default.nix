{ inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default

    ../../modules/system/common.nix

    ./configuration.nix
  ];
}
