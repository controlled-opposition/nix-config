{
  pkgs,
  inputs,
  ...
}:

{

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
  };

  programs.git.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 3";
    };

  };

  environment.variables = {
    NH_FILE = "/home/rick/.config/nix-config/default.nix";
    NH_ATTRP = "nixosConfigurations.lemon";
  };

  environment.systemPackages = builtins.attrValues {
    tack = inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default;
    helium-flake = inputs."helium-flake".packages.${pkgs.stdenv.hostPlatform.system}.default;

    inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
      codex
      pi
      ;

    inherit (pkgs)
      vim
      wget
      nixd
      nixfmt
      google-chrome
      faugus-launcher

      clang
      gnumake
      cmake
      libtool
      ;
  };

  services.crossmacro.enable = true;
  services.crossmacro.users = [
    "rick"
  ];

  programs.fish.enable = true;

  programs.firefox.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;

}
