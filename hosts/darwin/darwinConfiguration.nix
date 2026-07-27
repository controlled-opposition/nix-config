{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "Evericks-MacBook-Air";

  users.users.everick.home = "/Users/everick";
  system.primaryUser = "everick";

  system = {
    stateVersion = 6;
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  };

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    cmake
    nodejs
    bun
    nixd
    nixfmt
    nil
    uv
    python3
    alejandra
    statix
  ];
  fonts.packages = with pkgs; [
    iosevka-bin
  ];

}
