{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.users.weasel = {
    enable = true;
    imports = [
      ../../modules/language-tools
      ../../modules/nvf
      ../../modules/ai
    ];
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
