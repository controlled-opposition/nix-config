{ inputs, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "everick";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps =
      map
        (name: {
          inherit name;
          trusted = true;
        })
        [
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
      "zed"
      "spotify"
      "helium-browser"
    ];
  };
}
