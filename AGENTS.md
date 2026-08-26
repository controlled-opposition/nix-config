# Repository instructions

## Scope

This repository manages NixOS, WSL, nix-darwin, and standalone Home Manager configurations. It uses Tack and `default.nix`, not Nix flakes. Do not add `flake.nix` or `flake.lock`. The `flakes` evaluator feature remains enabled because Tack uses `fetchTree`.

## Repository layout

- `default.nix` imports pinned dependencies and exports every system and Home Manager configuration.
- `hosts/lemon/` defines the Lemon NixOS desktop.
- `hosts/wsl/` defines the WSL system.
- `hosts/darwin/` defines the macOS system.
- `home/<user>/` defines each standalone Home Manager configuration.
- `modules/` contains reusable Home Manager modules.
- `wallpapers/` contains static desktop images.
- `.tack/` contains dependency declarations, the lock file, and generated imports.

Keep machine-specific settings under the matching `hosts/<name>/` directory. Keep user-specific settings under `home/<user>/`. Put shared behavior in `modules/` and import it where needed.

## Editing rules

- Use two-space indentation and standard `nixfmt` output.
- Keep modules small, with explicit imports and related options grouped under namespaces such as `programs`, `services`, and `environment`.
- Name host and user directories after their exported configuration keys.
- Do not edit `.tack/default.nix`; Tack generates it.
- When changing dependency pins, update both `.tack/pins.toml` and `.tack/pins.lock.json`.
- Preserve unrelated working-tree changes.

## Validation

Format every changed Nix file:

```sh
nixfmt path/to/file.nix
```

Evaluate each affected configuration without activating it. For Lemon, run:

```sh
nix eval -f ./default.nix \
  nixosConfigurations.lemon.config.system.build.toplevel.drvPath
```

Change the attribute for another exported configuration. There is no separate test suite, so successful formatting and evaluation are the minimum checks.

Use `nh` only on the matching machine when an activation test is needed:

```sh
nh os switch
nh os switch -f ./default.nix nixosConfigurations.wsl
nh darwin switch -f ./default.nix 'darwinConfigurations.Evericks-MacBook-Air'
nh home switch -f ./default.nix homeConfigurations.rick
```

Never test a host change by activating it on another host. Review the activation output before treating a system change as complete.

Inspect or update pinned inputs with:

```sh
tack look
tack update
tack update nixpkgs home-manager
```

## Commits and pull requests

Use a short, lower-case, imperative commit subject, such as `add chaotic nyx` or `replace limine with systemd boot`. Keep each commit focused and avoid vague subjects.

A pull request must name the affected hosts and users, summarize the behavior change, and list the evaluation or rebuild commands that ran. Call out pin changes. Add screenshots only for visible desktop, editor, or wallpaper changes.
