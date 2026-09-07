# Repository instructions

## Scope

This repository manages NixOS, WSL, and nix-darwin configurations with Hjem-managed user packages. It uses Nix flakes with `flake.nix` and `flake.lock`.

## Repository layout

- `flake.nix` declares pinned inputs and exports every system configuration.
- `hosts/citrus/` defines the Citrus NixOS desktop.
- `hosts/rubus/` defines the Rubus WSL system.
- `hosts/malus/` defines the Malus macOS system.
- `home/<user>/` defines each Hjem user module.
- `modules/` contains reusable modules and related static files.
- `wallpapers/` contains static desktop images.
- `flake.lock` records resolved input revisions and hashes.

Keep machine-specific settings under the matching `hosts/<name>/` directory. Keep user-specific settings under `home/<user>/`. Put shared behavior in `modules/` and import it where needed.

## Editing rules

- Use two-space indentation and standard `nixfmt` output.
- Keep modules small, with explicit imports and related options grouped under namespaces such as `programs`, `services`, and `environment`.
- Name host and user directories after their exported configuration keys.
- When changing dependency pins, update `flake.lock` with `nix flake update`.
- Preserve unrelated working-tree changes.

## Validation

Format every changed Nix file:

```sh
nixfmt path/to/file.nix
```

Evaluate each affected configuration without activating it. For Citrus, run:

```sh
nix eval .#nixosConfigurations.citrus.config.system.build.toplevel.drvPath
```

Change the attribute for another exported configuration. There is no separate test suite, so successful formatting and evaluation are the minimum checks.

Use `nh` only on the matching machine when an activation test is needed. The system activation also applies the matching Hjem user configuration:

```sh
nh os switch . -H citrus
nh os switch . -H rubus
nh darwin switch . -H malus
```

Never test a host change by activating it on another host. Review the activation output before treating a system change as complete.

Inspect or update pinned inputs with:

```sh
nix flake metadata
nix flake update
nix flake update nixpkgs hjem
```

## Commits and pull requests

Use a short, lower-case, imperative commit subject, such as `add chaotic nyx` or `replace limine with systemd boot`. Keep each commit focused and avoid vague subjects.

A pull request must name the affected hosts and users, summarize the behavior change, and list the evaluation or rebuild commands that ran. Call out pin changes. Add screenshots only for visible desktop, editor, or wallpaper changes.
