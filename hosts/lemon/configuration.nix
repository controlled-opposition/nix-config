# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{

  # Bootloader.
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.limine = {
    extraEntries = ''
      /Windows
      protocol: efi
      path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
    '';
    style.wallpapers = [
      ../../wallpapers/wallhaven-42xge6.png
      ../../wallpapers/wallhaven-qr3mk7.png
    ];

  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "lemon"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."rick" = {
    isNormalUser = true;
    description = "rick";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [ ];
  };

  #services.lact.enable = true;

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
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

  environment.systemPackages = with pkgs; [
    inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default
    vim
    wget
    nixd
    nixfmt
    google-chrome
    faugus-launcher
  ];

  services.crossmacro.enable = true;
  services.crossmacro.users = [
    "rick"
  ];

  programs.fish.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.amdgpu.overdrive.enable = true;
  hardware.amdgpu.initrd.enable = true;

  programs.firefox.enable = true;
  nix.settings.auto-optimise-store = true;

  programs.steam.enable = true;

  system.stateVersion = "26.05";

  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;

}
