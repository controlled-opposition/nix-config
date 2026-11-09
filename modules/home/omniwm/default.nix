{ inputs, pkgs, ... }:
{
  programs.omniwm = {
    enable = true;
    package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.omniwm-bin;
  };
}
