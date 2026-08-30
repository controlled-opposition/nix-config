{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };

  hjem.users.everick = {
    enable = true;
    imports = [
      ../../modules/emacs
      ../../modules/nvf
    ];
    packages = builtins.attrValues {
      inherit (pkgs)
        bat
        discord
        fd
        fish
        fzf
        git
        kitty
        micro
        nh
        obsidian
        tmux
        zellij
        zoxide
        zoom-us
        ;
    };
  };
}
