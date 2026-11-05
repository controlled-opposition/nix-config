{ inputs, ... }:
{
  imports = [
    inputs.determinate.nixosModules.default
    inputs.nixos-wsl.nixosModules.default

    ../../modules/system/common.nix

    ./configuration.nix
  ];
}
