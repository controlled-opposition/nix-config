{ pkgs, ... }:
{
  imports = [
    ../../modules/home/common.nix
    ../../modules/home/zoxide
    ../../modules/home/emacs
    ../../modules/home/omniwm
  ];

  home = {
    username = "everick";
    homeDirectory = "/Users/everick";
    stateVersion = "25.11";

    packages = builtins.attrValues {

      inherit (pkgs)
        discord
        obsidian
        zoom-us
        ;
    };
  };
}
