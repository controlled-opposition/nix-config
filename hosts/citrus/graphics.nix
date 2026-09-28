{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.amdgpu.overdrive.enable = true;
  hardware.amdgpu.initrd.enable = true;

  hardware.facter.reportPath = ./facter.json;

  #services.lact.enable = true;
}
