{ inputs, ... }:
{
  imports = [
    inputs.umbriel.nixosModules.default
    inputs.noctalia.nixosModules.default
  ];

  programs.umbriel.enable = true;
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    # Started by Umbriel's native TOML configuration.
    systemd.enable = false;
  };

  services.displayManager.defaultSession = "umbriel";
}
