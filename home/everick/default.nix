{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.users.everick = {
    enable = true;
    imports = [
      ../../modules/nvf
    ];
    packages = builtins.attrValues {
      inherit (pkgs)
        discord
        fish
        git
        kitty
        micro
        obsidian
        tmux
        zellij
        zoom-us
        zoxide
        ;
    };
  };
}
