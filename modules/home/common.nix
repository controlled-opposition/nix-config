{ inputs, pkgs, ... }:
{
  imports = [
    ./language-tools
    ./direnv
    ./git
    ./zoxide
    ./ghostty
    ./jujutsu
    ./starship
    ./mise
    ./nushell
  ];

  home.packages = [
    pkgs.kitty
    pkgs.bun
    pkgs.nodejs
    pkgs.uv
    pkgs.starship
    pkgs.yazi
    inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.sheldon
    pkgs.lmstudio
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.herdr-bin
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.claude-code-bin
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.pi-bin
  ];
}
