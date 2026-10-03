{

  nixpkgs.hostPlatform.system = "aarch64-darwin";

  nix.settings.auto-optimise-store = true;

  system.stateVersion = 6;

  networking = {
    hostName = "malus";
    localHostName = "malus";
    computerName = "malus";
  };

  services.tailscale.enable = true;

}
