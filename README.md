# nix-config

This repository defines NixOS, WSL, and nix-darwin configurations with Hjem-managed user packages. [`flake.nix`](./flake.nix) defines the configurations and [`flake.lock`](./flake.lock) pins their dependencies.

## Configurations

| Attribute | Target |
| --- | --- |
| `nixosConfigurations.citrus` | NixOS desktop |
| `nixosConfigurations.rubus` | Rubus NixOS on WSL |
| `darwinConfigurations.malus` | Malus macOS laptop |

Host modules live in [`hosts/`](./hosts), Hjem user modules live in [`home/`](./home), and shared modules live in [`modules/`](./modules).

## Rebuild a system

Native flakes require the `nix-command` and `flakes` evaluator features. The host configurations enable both features.

On the first Citrus rebuild from a configuration that does not enable those features, run:

```sh
nh os switch --option experimental-features 'nix-command flakes' \
  . -H citrus
```

For later Citrus rebuilds, run from the repository root:

```sh
nh os switch . -H citrus
```

Select the WSL or macOS configuration explicitly:

```sh
nh os switch . -H rubus
nh darwin switch . -H malus
```

Each system imports Hjem's matching NixOS or nix-darwin module. A system rebuild installs the packages declared for Rick, Weasel, or Everick under `hjem.users.<name>.packages`.

## Pi configuration

Pi package declarations, skills, MCP configuration, and the Pi VCC configuration are kept under [`dotfiles/.pi/agent/`](./dotfiles/.pi/agent/) and [`dotfiles/.config/mcp/`](./dotfiles/.config/mcp/). From the repository root, link them with GNU Stow:

```sh
stow --no-folding --ignore='(emacs|fish|kitty)' --dir=. --target="$HOME" dotfiles
```

This links the configuration files and skills but leaves Pi's downloaded packages, dependencies, credentials, and sessions machine-local. The NixOS MCP server is configured lazily and is downloaded by `nix run` on first use. Install missing Pi packages on a new machine with `pi install` using the entries in `dotfiles/.pi/agent/settings.json`.

## Check a configuration

Evaluate a configuration without activating it:

```sh
nix eval .#nixosConfigurations.citrus.config.system.build.toplevel.drvPath
```

Change the attribute to check WSL or nix-darwin. Format every changed Nix file with `nixfmt` before evaluation.

## Update dependencies

Inspect or update the pinned inputs with Nix:

```sh
nix flake metadata
nix flake update
nix flake update nixpkgs hjem
```
