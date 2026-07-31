{
  services.flatpak = {
    enable = true;
    update.onActivation = true;
  };

  services.flatpak.packages = [
    "org.vinegarhq.Sober"
  ];
}
