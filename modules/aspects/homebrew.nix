_: {
  den.aspects.homebrew.darwin = {
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = "everick";
      autoMigrate = true;
    };

    homebrew = {
      enable = true;
      onActivation.cleanup = "zap";
      brews = [ ];
      casks = [
        "google-chrome"
        "codex-app"
        "anki"
        "visual-studio-code"
        "finetune"
      ];
    };
  };
}
