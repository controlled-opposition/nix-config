{ pkgs, ... }:
{
  packages = builtins.attrValues {
    inherit (pkgs)
      # Language servers
      emmylua-ls
      nil
      nixd

      # Formatters
      alejandra
      nixfmt

      # Linters
      statix
      ;
  };
}
