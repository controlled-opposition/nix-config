{ inputs, pkgs, ... }:
{
  programs.pi-coding-agent = {
    enable = true;
    package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.pi-bin;
    mutableSettings = true;
    settings = {
      defaultModel = "gpt-6.1-sol";
      defaultProvider = "openai";
      hideThinkingBlock = false;
      npmCommand = [ "bun" ];
      packages = [
        "npm:pi-web-access"
        "npm:@sting8k/pi-vcc"
      ];
      theme = "system";
    };
  };
}
