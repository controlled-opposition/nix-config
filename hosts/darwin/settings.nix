{
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system = {
    stateVersion = 6;
  };

}
