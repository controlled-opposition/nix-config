# nix-config

This repository defines NixOS, WSL, nix-darwin, and standalone Home Manager configurations. [Tack](https://github.com/manic-systems/tack) pins the dependencies imported by [`default.nix`](./default.nix).

## Configurations

| Attribute | Target |
| --- | --- |
| `nixosConfigurations.lemon` | NixOS desktop |
| `nixosConfigurations.wsl` | NixOS on WSL |
| `darwinConfigurations."Evericks-MacBook-Air"` | macOS laptop |
| `homeConfigurations.rick` | Rick's Linux home |
| `homeConfigurations.weasel` | Weasel's Linux home |
| `homeConfigurations.everick` | Everick's macOS home |

Host modules live in [`hosts/`](./hosts), user modules live in [`home/`](./home), and shared modules live in [`modules/`](./modules).

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

## Activate a Home Manager configuration

After a system rebuild, activate the matching standalone Home Manager configuration. Replace `rick` with `weasel` or `everick` for another user.

```sh
nh home switch -f ./default.nix homeConfigurations.rick
```

## Check a configuration

Evaluate a configuration without activating it:

```sh
nix eval -f ./default.nix \
  nixosConfigurations.lemon.config.system.build.toplevel.drvPath
```

Change the attribute to check another exported configuration. Format every changed Nix file with `nixfmt` before evaluation.

## Update dependencies

Inspect or update the pinned inputs with Tack:

```sh
tack look
tack update
tack update nixpkgs home-manager
```

Tack reads pin declarations from [`.tack/pins.toml`](./.tack/pins.toml) and writes resolved revisions and hashes to [`.tack/pins.lock.json`](./.tack/pins.lock.json). Commit both files after a pin change. Do not edit `.tack/default.nix`; Tack generates it.
