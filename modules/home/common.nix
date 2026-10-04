{ pkgs, ... }:
{
  imports = [
    ./language-tools
    ./ai
    ./direnv
    ./git
    ./codex
    ./zoxide
    ./ghostty
  ];

  home.packages = [
    pkgs.mise
    pkgs.kitty
    pkgs.bun
    pkgs.nodejs
    pkgs.uv
    pkgs.starship
    pkgs.yazi
  ];
}
