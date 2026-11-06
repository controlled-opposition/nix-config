{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.bun
          pkgs.mise
          pkgs.nixd
          config.treefmt.build.wrapper
        ];
      };
    };
}
