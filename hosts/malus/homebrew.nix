{ config, inputs, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "everick";
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = builtins.attrNames config.nix-homebrew.taps ++ [
      {
        name = "specstoryai/tap";
        trusted = true;
      }
    ];
    brews = [
      "specstory"
    ];

    casks = [
      "chatgpt"
      "google-chrome"
      "visual-studio-code"
      "zed"
      "spotify"
      "helium-browser"
    ];
  };
}
