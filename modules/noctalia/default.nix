{ inputs, ... }:
{
  # The Noctalia flake module has the recommended-services integration that
  # this configuration uses, so prefer it over the module bundled in nixpkgs.
  disabledModules = [
    "programs/wayland/noctalia.nix"
  ];

  imports = [
    inputs.noctalia.nixosModules.default
  ];

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

}
