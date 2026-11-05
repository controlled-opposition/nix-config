{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    programs = {
      biome.enable = true;
      deadnix.enable = true;
      nixfmt.enable = true;
      statix.enable = true;
      taplo.enable = true;
    };
    settings.formatter.biome.options = [ "--error-on-warnings" ];
  };
}
