{ inputs, ... }:
{

  imports = [
    ./darwinConfiguration.nix
    ./homebrew.nix
    inputs.home-manager.darwinModules.home-manager
  ];
}
