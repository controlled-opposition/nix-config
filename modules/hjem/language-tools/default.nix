{ pkgs, ... }:
{
  packages = builtins.attrValues {
    inherit (pkgs)
      # Language servers
      nixd
      nil

      # Formatters
      nixfmt

      # Linters
      statix
      deadnix

      #other
      rustup
      ;
  };
}
