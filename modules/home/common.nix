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
    ./pi
  ];

  home.backupFileExtension = "backup";

  home.packages = [
    pkgs.kitty
    pkgs.bun
    pkgs.nodejs
    pkgs.uv
    pkgs.starship
    pkgs.yazi
    pkgs.antidote
    pkgs.lmstudio
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.herdr-bin
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.claude-code-bin
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.herdr-app-bin
  ];
}
