{ ... }:
{
  environment.laminix.enable = true;

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
  };
}
