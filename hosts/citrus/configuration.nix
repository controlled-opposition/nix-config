{ inputs, pkgs, ... }:
{
  environment.systemPackages =
    builtins.attrValues {
      inherit (pkgs)
        nh
        gh
        wl-clipboard
        ;
    }
    ++ [
      inputs.butter.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.quadra.packages.${pkgs.stdenv.hostPlatform.system}.quadra
    ];

  programs.nix-ld.enable = true;

  programs.firefox.enable = true;

  system.stateVersion = "26.05";
}
