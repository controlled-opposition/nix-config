# nix-config

This repository defines NixOS, WSL, and nix-darwin configurations with Hjem-managed user packages. [Tack](https://github.com/manic-systems/tack) pins the dependencies imported by [`default.nix`](./default.nix).

## Configurations

| Attribute | Target |
| --- | --- |
| `nixosConfigurations.lemon` | NixOS desktop |
| `nixosConfigurations.wsl` | NixOS on WSL |
| `darwinConfigurations."Evericks-MacBook-Air"` | macOS laptop |

Host modules live in [`hosts/`](./hosts), Hjem user modules live in [`home/`](./home), and shared modules live in [`modules/`](./modules).

## Rebuild a system

Tack uses Nix's `fetchTree` built-in. The Nix evaluator must therefore enable `nix-command` and `flakes`, even though this repository has no `flake.nix` or `flake.lock`.

On the first Lemon rebuild from a configuration that does not enable those features, run:

```sh
nh os switch --option experimental-features 'nix-command flakes' \
  -f ./default.nix nixosConfigurations.lemon
```

The activated Lemon configuration sets `NH_FILE` and `NH_ATTRP`. Later rebuilds need only:

```sh
nh os switch
```

Select the WSL or macOS configuration explicitly:

```sh
nh os switch -f ./default.nix nixosConfigurations.wsl
nh darwin switch -f ./default.nix 'darwinConfigurations.Evericks-MacBook-Air'
```

Each system imports Hjem's matching NixOS or nix-darwin module. A system rebuild installs the packages declared for Rick, Weasel, or Everick under `hjem.users.<name>.packages`.

## Check a configuration

Evaluate a configuration without activating it:

```sh
nix eval -f ./default.nix \
  nixosConfigurations.lemon.config.system.build.toplevel.drvPath
```

Change the attribute to check WSL or nix-darwin. Format every changed Nix file with `nixfmt` before evaluation.

## Update dependencies

Inspect or update the pinned inputs with Tack:

```sh
tack look
tack update
tack update nixpkgs hjem
```

Tack reads pin declarations from [`.tack/pins.toml`](./.tack/pins.toml) and writes resolved revisions and hashes to [`.tack/pins.lock.json`](./.tack/pins.lock.json). Commit both files after a pin change. Do not edit `.tack/default.nix`; Tack generates it.
