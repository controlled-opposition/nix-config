{ pkgs, ... }:
{
  packages = with pkgs; [
    discord
    eza
    fd
    fish
    fzf
    git
    helix
    kitty
    obsidian
    spotify
    tmux
    vscode
    zoxide
  ];
}
