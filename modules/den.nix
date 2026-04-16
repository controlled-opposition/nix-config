{ inputs, ... }:
{
  imports = [
    inputs.den.flakeModule
    ./hosts.nix
    ./aspects/darwin.nix
    ./aspects/everick.nix
    ./aspects/homebrew.nix
    ./aspects/nvf.nix
    ./aspects/wsl.nix
  ];
}
