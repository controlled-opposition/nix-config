{

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform.system = "aarch64-darwin";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  system.stateVersion = 6;

  networking = {
    hostName = "malus";
    localHostName = "malus";
    computerName = "malus";
  };

}
