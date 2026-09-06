{ options, pkgs, ... }:
let
  isHjemModule = options ? files;
in
{
  config =
    if isHjemModule then
      {
        packages = [ pkgs.kdePackages.dolphin ];

      }
    else
      {
        programs.hyprland = {
          enable = true;
          withUWSM = true;
        };
      };
}
