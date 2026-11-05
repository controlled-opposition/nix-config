{

  nixpkgs.hostPlatform.system = "aarch64-darwin";

  determinateNix = {
    enable = true;
    customSettings = {
      auto-optimise-store = true;
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [ "root" ];
    };
  };

  nix.enable = false;

  system.stateVersion = 6;

  networking = {
    hostName = "malus";
    localHostName = "malus";
    computerName = "malus";
  };

  services.tailscale.enable = true;

}
