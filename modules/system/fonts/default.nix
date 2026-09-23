{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.jetbrains-mono
    pkgs.aporetic-bin
    pkgs.commit-mono
    pkgs.ioskeley-mono.standard
  ];
}
