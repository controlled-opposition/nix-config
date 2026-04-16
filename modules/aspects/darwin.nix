{ den, inputs, ... }:
{
  den.aspects.Evericks-MacBook-Air = {
    includes = [
      den._.hostname
      den.aspects.darwin-system
      den.aspects.homebrew
    ];
  };

  den.aspects.darwin-system.darwin =
    { pkgs, ... }:
    {
      imports = [
        inputs.determinate.darwinModules.default
        inputs.nix-homebrew.darwinModules.nix-homebrew
      ];

      nixpkgs.config.allowUnfree = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      determinateNix.enable = true;

      system = {
        stateVersion = 6;
        configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
      };

      environment.systemPackages = with pkgs; [
        gcc
        gnumake
        cmake
        nodejs
        bun
        nixd
        nixfmt
        nil
        uv
        python3
        alejandra
        statix
      ];
    };
}
