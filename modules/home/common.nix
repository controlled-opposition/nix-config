{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nvf.homeManagerModules.default
    ./language-tools
    ./nvf
    ./ai
    ./skills
    ./direnv
    ./codex
    ./starship
    ./helix
  ];

  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    pkgs.mise
    pkgs.kitty
    pkgs.bun
    pkgs.nodejs
    pkgs.uv
  ];
}
