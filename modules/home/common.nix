{ inputs, pkgs, ... }:
{
  imports = [
    ./language-tools
    ./direnv
    ./git
    ./zoxide
    ./ghostty
    ./jujutsu
    ./zsh
    ./starship
    ./mise
  ];

  home.packages = [
    pkgs.mise
    pkgs.kitty
    pkgs.bun
    pkgs.nodejs
    pkgs.uv
    pkgs.starship
    pkgs.yazi
    inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
