{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    iosevka-bin
  ];
}
