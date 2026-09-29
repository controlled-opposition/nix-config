---
name: home-manager-rebuild
description: Validate and rebuild standalone Home Manager flake configurations after modifying any file that affects a homeConfigurations output. Do not use for Home Manager integrated into NixOS or nix-darwin.
---

# Rebuild standalone Home Manager configurations

Use this skill when a task modifies a standalone Home Manager configuration exported through `homeConfigurations`.

Determine applicability from the flake output and its import graph, not from file names or directories. A file such as `home/foo.nix` may be a reusable module, but if it is imported by the targeted `homeConfigurations.<name>` output, changes to it affect that standalone configuration.

Do not use this skill when:

- Home Manager is integrated into a NixOS configuration through `home-manager.users`.
- Home Manager is integrated into a nix-darwin configuration.
- The task modifies a reusable Home Manager module without targeting or affecting a standalone `homeConfigurations` output.

A reusable module may still be part of a standalone configuration. If the task modifies that module as part of changing a `homeConfigurations` target, use this skill.

## Rebuild after changes

After completing a coherent set of changes that affects a standalone Home Manager configuration, rebuild it before considering the task complete.

Identify the exact configuration name from `homeConfigurations` in `flake.nix`.

If operating on the machine that the configuration targets, build and activate it:

```sh
HOME_MANAGER_BACKUP_EXT=backup nh home switch . -c <configuration>
```

If operating on another machine, build it without activation:

```sh
nh home build . -c <configuration>
```

Never activate a Home Manager configuration intended for another machine.

Inspect the rebuild output and resolve configuration errors caused by the changes before finishing the task.

Do not update flake inputs as part of rebuilding unless the user explicitly requests an input update.

Do not use `nh os` or `nh darwin` to rebuild a standalone Home Manager configuration.
