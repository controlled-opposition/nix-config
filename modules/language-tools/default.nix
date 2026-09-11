{ pkgs, ... }:
{
  packages = builtins.attrValues {
    inherit (pkgs)
      # Language servers
      nixd

      # Formatters
      nixfmt

      # Linters
      statix
      deadnix
      ;
  };
}
