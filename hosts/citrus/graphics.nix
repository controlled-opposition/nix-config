{ pkgs, ... }:
let
  g60sdEdid = pkgs.runCommand "g60sd-hdmi-edid" { nativeBuildInputs = [ pkgs.python3 ]; } ''
    mkdir -p "$out/lib/firmware/edid"
    python3 ${./edid/g60sd-hdmi.py} ${./edid/g60sd-hdmi-native.bin} \
      "$out/lib/firmware/edid/g60sd-hdmi.bin"
  '';
in
{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.amdgpu.overdrive.enable = true;
  hardware.amdgpu.initrd.enable = true;

  hardware.facter.reportPath = ./facter.json;

  # Expose native high-refresh HDMI timings in standalone DisplayID for Linux 7.2.
  hardware.display.edid.packages = [ g60sdEdid ];
  hardware.display.outputs."HDMI-A-1".edid = "g60sd-hdmi.bin";
  # Enable only if the G60SD is connected to the other GPU HDMI port.
  # hardware.display.outputs."HDMI-A-2".edid = "g60sd-hdmi.bin";
  boot.initrd.extraFirmwarePaths = [ "edid/g60sd-hdmi.bin" ];

  boot.kernelParams = [
    "amdgpu.dcfeaturemask=0x402"
  ];
}
