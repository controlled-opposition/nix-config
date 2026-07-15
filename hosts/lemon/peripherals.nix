{

  services.udev.extraRules = ''
    # Pulsar Mice WebHID support
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3710", MODE="0666", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3710", ATTR{bInterfaceClass}=="03", MODE="0666", TAG+="uaccess", ENV{libsane_matched}="yes"
  '';

  hardware.wooting.enable = true;
}
