{ inputs, pkgs, ... }:
{
  imports = [
    ./language-tools
    ./ai
    ./direnv
    ./git
    ./codex
    ./zoxide
    ./ghostty
    ./jujutsu
  ];

  home.packages = [
    pkgs.mise
    pkgs.kitty
    pkgs.bun
    pkgs.nodejs
    pkgs.uv
    pkgs.starship
    pkgs.yazi
    inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
