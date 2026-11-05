{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      # Language servers
      nixd
      nil

      # Formatters
      nixfmt
      shfmt

      # Linters
      statix
      deadnix
      shellcheck

      #other
      rustup
      python3
      gcc
      gnumake
      cmake
      ;
  };
}
