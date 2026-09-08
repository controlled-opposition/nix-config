{ inputs, ... }:
{
  imports = [
    inputs.umbriel.nixosModules.default
    ../../modules/noctalia
  ];
  programs.hyprland.enable = true;
  programs.umbriel.enable = true;
}
