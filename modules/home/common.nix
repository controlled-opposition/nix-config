{ inputs, pkgs, ... }:
{
  imports = [
    ./language-tools
    ./ai
    ./direnv
    ./codex
    ./zoxide
  ];

  home.packages = [
    inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.coding-agent
    pkgs.mise
    pkgs.kitty
    pkgs.bun
    pkgs.nodejs
    pkgs.uv
    pkgs.starship
    pkgs.yazi
  ];
}
