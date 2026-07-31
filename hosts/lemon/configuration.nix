{
  pkgs,
  inputs,
  ...
}:

{

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

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
  };

  programs.git.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 3";
    };

  };
  nix.package = pkgs.lixPackageSets.stable.lix;
  documentation.enable = false;
  environment.variables = {
    NH_FILE = "/home/rick/.config/nix-config/default.nix";
    NH_ATTRP = "nixosConfigurations.lemon";
  };

  environment.systemPackages = with pkgs; [
    inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default
    # helium-flake imports nixpkgs separately; pass this host's permitted
    # Widevine package so its license policy is used.
    (inputs."helium-flake".packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      widevine-cdm = pkgs.widevine-cdm;
    })
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

  programs.firefox.enable = true;

  programs.steam.enable = true;

  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;

}
