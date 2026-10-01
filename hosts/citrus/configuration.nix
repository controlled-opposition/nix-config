{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      nh
      gh
      ;
  };

  services.crossmacro.enable = true;
  services.crossmacro.users = [
    "rick"
  ];

  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  programs.firefox.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;

}
