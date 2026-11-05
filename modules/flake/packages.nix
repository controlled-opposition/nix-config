{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      inherit (pkgs) lib;
      allPackages = {
        claude-code-bin = pkgs.callPackage ../../packages/claude-code-bin { };
        herdr-app-bin = pkgs.callPackage ../../packages/herdr-app-bin { };
        herdr-bin = pkgs.callPackage ../../packages/herdr-bin { };
        mise-bin = pkgs.callPackage ../../packages/mise-bin { };
        nutmeg = pkgs.callPackage ../../packages/nutmeg { };
        pi-bin = pkgs.callPackage ../../packages/pi-bin { };
      };
    in
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      packages = lib.filterAttrs (_: lib.meta.availableOn pkgs.stdenv.hostPlatform) allPackages;

      apps.update.program = pkgs.writeShellApplication {
        name = "update-packages";
        text = ''
          pids=()
          ${lib.concatLines (
            lib.mapAttrsToList (attr: pkg: ''
              UPDATE_NIX_ATTR_PATH=${attr} ${lib.escapeShellArgs pkg.updateScript} &
              pids+=("$!")
            '') allPackages
          )}
          status=0
          for pid in "''${pids[@]}"; do
            wait "$pid" || status=1
          done
          exit "$status"
        '';
      };
    };
}
