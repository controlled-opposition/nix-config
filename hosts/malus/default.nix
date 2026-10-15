{ ... }:
{
  imports = [
    ../../modules/system/common.nix
    ../../modules/system/fonts

    ./configuration.nix
    ./homebrew.nix
    ./settings.nix
    ./users.nix
  ];
}
