{ pkgs, inputs, ... }:

{
  imports = [
    inputs.determinate.darwinModules.default
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

  determinateNix.enable = true;

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
  ];
}
