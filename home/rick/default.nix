{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.users.rick = {
    enable = true;
    imports = [
      ../../modules/language-tools
      ../../modules/nvf
    ];
    packages = builtins.attrValues {
      inherit (pkgs.kdePackages) dolphin;

      inherit (pkgs)
        btop
        discord
        fastfetch
        fish
        git
        helix
        kitty
        obsidian
        spotify
        tmux
        vscode
        zed-editor
        zoxide
        gopeed
        ;
    };
  };
}
