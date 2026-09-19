{ inputs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  imports = [
    inputs.home-manager.darwinModules.home-manager

    ../../modules/system/common.nix
    ../../modules/system/cache
    ../../modules/system/emacs
    ../../modules/system/fonts
    ../../home/everick

    ./configuration.nix
    ./homebrew.nix
    ./settings.nix
    ./users.nix
  ];
}
