{ pkgs, ... }:
{
  fonts.packages = builtins.attrValues {
    inherit (pkgs.nerd-fonts)
      jetbrains-mono
      ;

    inherit (pkgs)
      iosevka-bin
      ;
  };
}
