{ ... }:
{

  imports = [
    ./darwinConfiguration.nix
    ./homebrew.nix
    ./settings.nix
    ./users.nix
    ../../modules/fonts
  ];
}
