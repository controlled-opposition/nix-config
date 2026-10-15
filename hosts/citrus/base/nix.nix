{ pkgs, ... }:
{
  nix.settings = {
    auto-optimise-store = true;

    fallback = true;

    extra-substituters = [
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.package = pkgs.nix;
  system.stateVersion = "26.05";

}
