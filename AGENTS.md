# Repository instructions

## Repository conventions

- Preserve unrelated working-tree changes.
- Put machine settings in `hosts/<name>/` and user settings in `home/<user>/`. Name host directories after exported configuration keys and user directories after `home-manager.users` keys.
- Assemble features and users in each host's `default.nix`, not `flake.nix`.
- Put shared system modules in `modules/system/`, NixOS-only modules in `modules/nixos/`, and Home Manager modules in `modules/home/`. Import modules explicitly.
- Use two-space indentation, small modules, and related option namespaces such as `programs`, `services`, and `environment`.
- Manage shell settings with [`modules/home/shell/`](./modules/home/shell/) and Pi's `settings.json` with [`modules/home/pi/`](./modules/home/pi/); keep credentials, sessions, and downloaded packages machine-local. Add Pi extensions only when requested.
- Edit `AGENTS.md` when appropriate. Leave `README.md` unchanged and add documentation only when explicitly asked. Keep documentation minimal; link to configuration files instead of copying option or shortcut lists.

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

If flakes are disabled, add `--extra-experimental-features 'nix-command flakes'` before `run`, or enable them in Nix configuration. Review activation output for errors.

## Update dependencies

Inspect pins with `nix flake metadata`. Update all inputs with `nix flake update`, or selected inputs with `nix flake update nixpkgs home-manager`. Review the `flake.lock` diff and [evaluate affected configurations](#validate-changes) before activation.

## Migrate shell dotfiles

Before the first Home Manager switch on citrus or malus, remove old Stow-created links to `~/.config/fish/config.fish` and `~/.zshrc`; back up any local files at those paths. Home Manager then owns the shell configuration through [`modules/home/shell/`](./modules/home/shell/).

## Commit and review

Use short, lower-case, imperative commit subjects, such as `add desktop packages`. Keep commits focused. In pull requests, name affected hosts and users; summarize behavior and pin changes; list evaluation or rebuild commands. Add screenshots only for visible desktop, editor, or wallpaper changes.
