{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.users.weasel = {
    enable = true;
    imports = [
      ../../modules/nvf
    ];
    packages = builtins.attrValues {
      inherit (pkgs)
        git
        nh
        obsidian
        spotify-player
        tmux
        uv
        zellij
        ;
    };
  };
}
