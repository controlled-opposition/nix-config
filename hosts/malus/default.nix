{ inputs, ... }:
{
  imports = [
    inputs.hjem.darwinModules.default

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
