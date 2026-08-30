{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.extraModules = [inputs.hjem-impure.hjemModules.default];
  hjem.users.weasel = {
    enable = true;
    impure.enable = true;
    imports = [
      ../../modules/emacs
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
