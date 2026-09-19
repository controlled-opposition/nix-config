{ pkgs, ... }:
{
  hjem.users.weasel = {
    enable = true;
    imports = [ ../../modules/hjem/common.nix ];
    packages = builtins.attrValues {
      inherit (pkgs)
        git
        jujutsu
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
