{ inputs, pkgs, ... }:
{
  hjem.specialArgs = { inherit inputs; };
  hjem.users.rick = {
    enable = true;
    imports = [
      ../../modules/hyprland
      ../../modules/nvf
    ];
    packages = builtins.attrValues {
      inherit (pkgs)
        btop
        discord
        fastfetch
        fish
        git
        helix
        kitty
        nil
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
