{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "everick";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      "specstoryai/tap"
    ];
    brews = [
      "libvterm"
      "libtool"
      "specstory"
    ];

    casks = [
      "google-chrome"
      "visual-studio-code"
      "finetune"
      "codex"
      "zed"
      "spotify"
      "helium-browser"
    ];
  };
}
