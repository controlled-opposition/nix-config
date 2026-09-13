{ pkgs, ... }:
{
  fonts.packages = [
      pkgs.jetbrains-mono
      pkgs.aporetic
      pkgs.commit-mono
      pkgs.ioskeley-mono.normal
  ];
}
