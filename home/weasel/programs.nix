{ pkgs, ... }:
{
  packages = with pkgs; [
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
  ];
}
