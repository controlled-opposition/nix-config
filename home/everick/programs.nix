{ pkgs, ... }:
{
  packages = with pkgs; [
    obsidian
    zoom-us
    kitty
    discord
    zoxide
    git
    nh
    bat
    fd
    fzf
    zellij
    micro
    tmux
  ];
}
