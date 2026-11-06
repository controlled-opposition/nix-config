# Repository instructions

## Repository conventions

- Preserve unrelated working-tree changes.
- Put machine settings in `hosts/<name>/`. Name each host directory after its exported configuration key.
- Put user settings in `home/<user>/`. Name each user directory after its `home-manager.users` key.
- Assemble features and users in each host's `default.nix`. Do not assemble them in `flake.nix`.
- Define flake outputs in flake-parts modules under `modules/flake/`. Import those modules from `flake.nix`. Put per-system outputs in `perSystem` and configurations in `flake`.
- Put shared system modules in `modules/system/`, NixOS-only modules in `modules/nixos/`, and Home Manager modules in `modules/home/`. Import modules explicitly.
- Manage zsh configuration with [`mise.toml`](./mise.toml) and [`dotfiles/`](./dotfiles/).
- Manage Pi settings with Home Manager. Manage Pi's `mcp.json` with mise. Install executables with NixOS, nix-darwin, or Home Manager. Keep credentials, sessions, and downloaded packages machine-local. Add Pi extensions only when requested.
- Edit `AGENTS.md` when appropriate. Do not add content to `README.md`; formatting it is allowed. Add other documentation only when explicitly requested. Keep documentation minimal. Link to configuration files instead of copying option or shortcut lists.
- Before running a version-control command, check for `.jj/`. In a colocated Jujutsu repository, use `jj`, not Git. This rule includes status, diffs, commits, and history changes.
- Do not add comments to code unless asked.

## Validate changes

Run all commands from the repository root. Prefer [`nh`](https://github.com/nix-community/nh) whenever it supports the operation; use Nix or mise directly otherwise.

1. Run `nix fmt` to format the repository. [`flake.nix`](./flake.nix) configures treefmt-nix.
2. Run `nix flake check` to verify formatting.
3. Evaluate each affected host or standalone Home Manager configuration. Do not activate it during evaluation.

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

Never activate a configuration on another machine. System and standalone Home Manager activations are separate. Switch the system before the matching user configuration. Run `nh` without `sudo`; it handles privilege escalation.

```sh
# citrus
nh os switch . -H citrus
nh home switch . -c 'rick@citrus' -b backup

# rubus
nh os switch . -H rubus
nh home switch . -c 'weasel@rubus' -b backup

# malus
nh darwin switch . -H malus
nh home switch . -c 'everick@malus' -b backup
```

Enable `nix-command` and `flakes` in the Nix configuration before using these commands. Review activation output for errors. Then [apply mise dotfiles](#apply-mise-dotfiles) for the matching user.

## Update dependencies

1. Run `nix flake metadata` to inspect pins.
2. Run `mise run update` to update all flake inputs and the release-pinned packages in [`packages/`](./packages/). To update selected inputs instead, run `nix flake update nixpkgs home-manager`.
3. Review the `flake.lock` and `packages/` diffs.
4. Before activation, [evaluate affected configurations](#validate-changes).

Give each package in `packages/` a `passthru.updateScript`. The `update` task in [`mise.toml`](./mise.toml) runs each script.

## Apply mise dotfiles

Run these commands from the repository root on the matching machine. First, switch Home Manager so it releases any old links. Inspect and back up conflicting targets before applying dotfiles. Avoid `--force` on unmanaged files.

```sh
mise trust ./mise.toml
mise bootstrap dotfiles apply --dry-run
mise bootstrap dotfiles apply
mise bootstrap dotfiles status
```

`mise install` alone does not apply dotfiles.

## Commit and review

Use short, lower-case, imperative commit subjects, such as `add desktop packages`. Keep commits focused.

In pull requests:

- Name the affected hosts and users.
- Summarize behavior and pin changes.
- List validation or rebuild commands.
- Add screenshots only for visible desktop, editor, or wallpaper changes.
