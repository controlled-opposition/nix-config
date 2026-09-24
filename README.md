# nix-config

This flake defines NixOS, WSL, and nix-darwin configurations alongside standalone Home Manager configurations.

Run commands from the repository root.

## Check changes

Format changed Nix files with `nixfmt path/to/file.nix`. Evaluate each affected host without activation:

```sh
nix eval .#nixosConfigurations.citrus.config.system.build.toplevel.drvPath
nix eval .#nixosConfigurations.rubus.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.malus.config.system.build.toplevel.drvPath
nix eval '.#homeConfigurations."rick@citrus".activationPackage.drvPath'
nix eval '.#homeConfigurations."weasel@rubus".activationPackage.drvPath'
nix eval '.#homeConfigurations."everick@malus".activationPackage.drvPath'
```

## Rebuild

Run only the commands for the current machine. System and Home Manager activations are separate; switch the system before the matching user configuration.

```sh
nh os switch . -H citrus
HOME_MANAGER_BACKUP_EXT=backup nh home switch . -c rick@citrus
nh os switch . -H rubus
HOME_MANAGER_BACKUP_EXT=backup nh home switch . -c weasel@rubus
nh darwin switch . -H malus
HOME_MANAGER_BACKUP_EXT=backup nh home switch . -c everick@malus
```

If flakes are disabled, add `--option experimental-features 'nix-command flakes'` after `switch`.
Check the activation output for errors.

## Update dependencies

Inspect pins with `nix flake metadata`. Update all inputs or name selected inputs:

```sh
nix flake update
nix flake update nixpkgs home-manager
```

Review the `flake.lock` diff. [Check affected hosts](#check-changes) before activation.

## Link dotfiles

1. Preview the links:

   ```sh
   stow --simulate --verbose --no-folding --dir=. --target="$HOME" dotfiles
   ```

2. Back up conflicting local files before replacing them. Do not use `--adopt` unless you intend to replace repository files with local content.

3. Apply the links:

   ```sh
   stow --no-folding --dir=. --target="$HOME" dotfiles
   ```

Repeat after adding files. For Citrus, [configure the desktop](./hosts/citrus/README.md).
