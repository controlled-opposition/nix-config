{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };

  hjem.users.weasel = {
    enable = true;
    imports = [
      ../../modules/emacs
      ../../modules/nvf
    ];
    packages = builtins.attrValues {
      inherit (pkgs)
        bash
        eza
        fd
        fzf
        git
        nh
        obsidian
        spotify-player
        tmux
        uv
        zellij
        zoxide
        ;
    };
  };
}
