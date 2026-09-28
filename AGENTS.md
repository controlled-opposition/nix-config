# Repository instructions

## Documentation

Only edit or update `AGENTS.md` when appropriate. Do not edit `README.md` or add new documentation unless explicity asked.

## Edit

- Preserve unrelated working-tree changes.
- Keep machine settings in `hosts/<name>/` and user settings in `home/<user>/`.
- Name host directories after exported configuration keys and user directories after `home-manager.users` keys.
- Assemble features and users in each host's `default.nix`, not `flake.nix`.
- Put shared system modules in `modules/system/`, NixOS-only modules in `modules/nixos/`, and Home Manager modules in `modules/home/`. Import modules explicitly.
- Use two-space indentation. Keep modules small. Group related options under namespaces such as `programs`, `services`, and `environment`.
- Keep Stow and Home Manager file ownership separate. Manage Pi's `settings.json` with [`modules/home/pi/`](./modules/home/pi/). Keep credentials, sessions, and downloaded packages machine-local.
- Add Pi extensions only when requested.
- Update dependency pins with `nix flake update`.
- Keep documentation minimal. Link to configuration files instead of copying option or shortcut lists.

## Check changes

Run commands from the repository root. Format changed Nix files with `nixfmt path/to/file.nix`. Evaluate each affected host without activation:

```sh
nix eval .#nixosConfigurations.citrus.config.system.build.toplevel.drvPath
nix eval .#nixosConfigurations.rubus.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.malus.config.system.build.toplevel.drvPath
nix eval '.#homeConfigurations."rick@citrus".activationPackage.drvPath'
nix eval '.#homeConfigurations."weasel@rubus".activationPackage.drvPath'
nix eval '.#homeConfigurations."everick@malus".activationPackage.drvPath'
```

There is no separate test suite.

## Rebuild

Activate only on the matching machine. System and standalone Home Manager activations are separate; switch the system before the matching user configuration:

```sh
nh os switch . -H citrus
HOME_MANAGER_BACKUP_EXT=backup nh home switch . -c rick@citrus
nh os switch . -H rubus
HOME_MANAGER_BACKUP_EXT=backup nh home switch . -c weasel@rubus
nh darwin switch . -H malus
HOME_MANAGER_BACKUP_EXT=backup nh home switch . -c everick@malus
```

If flakes are disabled, add `--option experimental-features 'nix-command flakes'` after `switch`. Review the activation output for errors.

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

Repeat after adding files.

## Commit and review

Use short, lower-case, imperative commit subjects, such as `add chaotic nyx`. Keep commits focused.

In pull requests, name the affected hosts and users. Summarize behavior and pin changes. List evaluation or rebuild commands.
Add screenshots only for visible desktop, editor, or wallpaper changes.
