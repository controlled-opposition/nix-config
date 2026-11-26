{ inputs, pkgs, ... }:

let
  flyline = inputs.flyline.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      nh
      gh
      ;
  };

  environment.shells = [ pkgs.bashInteractive ];
  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      if (( BASH_VERSINFO[0] >= 4 )) && [[ $TERM != dumb ]]; then
        enable -f ${flyline}/lib/libflyline.dylib flyline
      fi
    '';
  };
  programs.zsh.enable = true;

}
