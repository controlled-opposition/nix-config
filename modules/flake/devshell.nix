{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.bun
          pkgs.mise
          pkgs.nix
          pkgs.nixd
          config.treefmt.build.wrapper
        ];
      };
    };
}
