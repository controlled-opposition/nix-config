{ inputs, ... }:
{
  den = {
    hosts = {
      aarch64-darwin.Evericks-MacBook-Air.users.everick.classes = [ "user" ];

      x86_64-linux.wsl = {
        hostName = "nixos";
        intoAttr = [
          "nixosConfigurations"
          "nixos"
        ];
        instantiate = inputs.nixos-nixpkgs.lib.nixosSystem;
        wsl.enable = true;
        users.nixos.classes = [ "user" ];
      };
    };

    homes.aarch64-darwin.everick.pkgs = import inputs.nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
  };
}
