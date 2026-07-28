{ inputs, ... }:
{

  imports = [
    ./darwinConfiguration.nix
    ./homebrew.nix
    ./settings.nix
    ./users.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];
}
