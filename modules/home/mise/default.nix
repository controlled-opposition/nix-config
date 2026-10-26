{ inputs, pkgs, ... }:
{
  programs.mise = {
    enable = true;
    package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mise-bin;
  };
}
