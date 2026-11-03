{ inputs, pkgs, ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

  nix.settings.substituters = [ "https://cache.lantian.pub/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
}
