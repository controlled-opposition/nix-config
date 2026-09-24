{ ... }:
{
  imports = [
    ../../modules/system/common.nix
    ../../modules/system/cache
    ../../modules/system/emacs
    ../../modules/system/fonts

    ./configuration.nix
    ./homebrew.nix
    ./settings.nix
    ./users.nix
  ];
}
