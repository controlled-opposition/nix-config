# Repository instructions

## Repository conventions

- Preserve unrelated working-tree changes.
- Put machine settings in `hosts/<name>/` and user settings in `home/<user>/`. Name host directories after exported configuration keys and user directories after `home-manager.users` keys.
- Assemble features and users in each host's `default.nix`, not `flake.nix`.
- Put shared system modules in `modules/system/`, NixOS-only modules in `modules/nixos/`, and Home Manager modules in `modules/home/`. Import modules explicitly.
- Use two-space indentation, small modules, and related option namespaces such as `programs`, `services`, and `environment`.
- Manage zsh, Kitty, and Pi configuration with [`mise.toml`](./mise.toml) and [`dotfiles/`](./dotfiles/). NixOS, nix-darwin, or Home Manager still installs their executables; keep credentials, sessions, and downloaded packages machine-local. Add Pi extensions only when requested.
- Edit `AGENTS.md` when appropriate. Leave `README.md` unchanged and add documentation only when explicitly asked. Keep documentation minimal; link to configuration files instead of copying option or shortcut lists.
- Before running version-control commands, check for .jj/. In a colocated Jujutsu repository, use jj, not Git, including for status, diffs, commits, and history changes.
- Do not add comments to code unless asked.

## Validate changes

Run commands from the repository root. Format changed Nix files with `nixfmt path/to/file.nix`. Evaluate each affected host or standalone Home Manager configuration without activating it:

```sh
nix eval .#nixosConfigurations.citrus.config.system.build.toplevel.drvPath
nix eval .#nixosConfigurations.rubus.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.malus.config.system.build.toplevel.drvPath
nix eval '.#homeConfigurations."rick@citrus".activationPackage.drvPath'
nix eval '.#homeConfigurations."weasel@rubus".activationPackage.drvPath'
nix eval '.#homeConfigurations."everick@malus".activationPackage.drvPath'
```

There is no separate test suite.

## Activate on the matching machine

System and standalone Home Manager activations are separate: switch the system before the matching user configuration. Use `--inputs-from .` to run rebuild tools from the flake's pinned inputs. Never activate a configuration on another machine.

```sh
# citrus
sudo nix run --inputs-from . nixpkgs#nixos-rebuild -- switch --flake .#citrus
nix run --inputs-from . home-manager -- switch --flake '.#rick@citrus' -b backup

# rubus
sudo nix run --inputs-from . nixpkgs#nixos-rebuild -- switch --flake .#rubus
nix run --inputs-from . home-manager -- switch --flake '.#weasel@rubus' -b backup

# malus
sudo nix run --inputs-from . nix-darwin -- switch --flake .#malus
nix run --inputs-from . home-manager -- switch --flake '.#everick@malus' -b backup
```

If flakes are disabled, add `--extra-experimental-features 'nix-command flakes'` before `run`, or enable them in Nix configuration. Review activation output for errors. Then [apply mise dotfiles](#apply-mise-dotfiles) for the matching user.

## Update dependencies

Inspect pins with `nix flake metadata`. Run `mise run update` to update all flake inputs and the release-pinned packages in [`packages/`](./packages/), or update selected inputs with `nix flake update nixpkgs home-manager`. Give each package in `packages/` a `passthru.updateScript`; the `update` task in [`mise.toml`](./mise.toml) runs it. Review the `flake.lock` and `packages/` diffs and [evaluate affected configurations](#validate-changes) before activation.

## Apply mise dotfiles

From the repository root on the matching machine, switch Home Manager first so it releases any old links. Then run:

```sh
mise trust ./mise.toml
mise bootstrap dotfiles apply --dry-run
mise bootstrap dotfiles apply
mise bootstrap dotfiles status
```

Inspect and back up conflicting targets before applying; avoid `--force` on unmanaged files. `mise install` alone does not apply dotfiles.

## Commit and review

Use short, lower-case, imperative commit subjects, such as `add desktop packages`. Keep commits focused. In pull requests, name affected hosts and users; summarize behavior and pin changes; list evaluation or rebuild commands. Add screenshots only for visible desktop, editor, or wallpaper changes.
