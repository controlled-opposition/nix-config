{ pkgs, ... }:
{
  boot.loader = {
    limine.enable = true;
    efi.canTouchEfiVariables = true;
    limine = {
      extraEntries = ''
        /Windows
        protocol: efi
        path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
      '';
      style.wallpapers = [
        ../../../wallpapers/wallhaven-42xge6.png
        ../../../wallpapers/wallhaven-qr3mk7.png
      ];
    };

  };

  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto-znver4;
}