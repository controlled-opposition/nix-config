{ pkgs, ... }:

{
  wsl = {
    enable = true;
    defaultUser = "nixos";
    startMenuLaunchers = true;
    useWindowsDriver = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    nixfmt
    nixd
    cmake
    gcc
    gnumake

  ];

  services.pulseaudio.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

users.users.nixos = {
  isNormalUser = true;
  extraGroups = [ "wheel" ];

  packages = with pkgs; [
    eza
    fzf
    fd
    nh
    zellij
    uv
    obsidian
    emacs
    spotify-player
  ];
};

programs.git.enable = true;
programs.zoxide.enable = true;
programs.tmux.enable = true;






  system.stateVersion = "25.11"; 
}
