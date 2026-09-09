{ pkgs, inputs, ... }:

{

  environment.systemPackages = builtins.attrValues {
    inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system})
      codex
      pi
      ;


    inherit (pkgs)
      gcc
      gnumake
      cmake
      nodejs
      bun
      nixd
      nixfmt
      uv
      python3
      alejandra
      statix
      nh
      docker
      stow
      helix
      ;
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

}
