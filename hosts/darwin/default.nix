{ inputs, ... }:
{

  imports = [
    ./darwinConfiguration.nix
    ./homebrew.nix
    ./settings.nix
    ./users.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];
}
