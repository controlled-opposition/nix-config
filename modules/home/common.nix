{ inputs, pkgs, ... }:
{
  imports = [
    ./language-tools
    ./direnv
    ./git
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
    inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.spotifast.packages.${pkgs.stdenv.hostPlatform.system}.spotifast
  ];
}
