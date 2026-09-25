---
name: nh
description: Use the nh CLI to build or activate NixOS, nix-darwin, and Home Manager configurations, search Nix packages and options, or clean Nix generations and store paths. Load when a task involves nh commands.
---

# Use nh

`nh` provides a unified interface for common NixOS, nix-darwin, Home Manager, search, and cleanup operations.

Prefer `nh` over invoking the corresponding lower-level rebuild or cleanup commands directly when `nh` supports the required operation.

Check the installed version and local help before using flags or behavior you have not verified:

```sh
nh --version
nh --help
```

Use the relevant subcommand's help when needed:

```sh
nh os switch --help
nh home switch --help
nh darwin switch --help
nh search --help
nh clean --help
```

## Build and activate configurations

Pass the flake directory to `nh`, not a flake installable such as `.#host`.

Use `.` when operating from the flake root.

Select the command group matching the configuration type:

```sh
nh os build . -H <hostname>
nh os test . -H <hostname>
nh os switch . -H <hostname>

nh darwin build . -H <hostname>
nh darwin switch . -H <hostname>

nh home build . -c <configuration>
nh home switch . -c <configuration>
```

Use the exact hostname or Home Manager configuration name exported by the flake. Inspect `flake.nix`, its outputs, or repository documentation when the target is unclear.

Command behavior:

- `build` builds the configuration without activating it.
- `nh os test` activates a NixOS configuration without making it the boot default.
- `nh os switch` activates a NixOS configuration and makes it the boot default.
- `nh darwin switch` activates a nix-darwin configuration.
- `nh home switch` activates a standalone Home Manager configuration.

If Home Manager is integrated into NixOS or nix-darwin, activate it through the corresponding system configuration rather than treating it as a standalone `homeConfigurations` target.

Follow the activation policy required by the current task or by a more specific skill. When only validation is required, use `build`.

Do not prefix `nh` commands with `sudo` unless local documentation or verified command behavior specifically requires it. Allow `nh` to handle privilege escalation.

Inspect command output and resolve errors caused by the current changes before considering validation complete.

## Flake inputs

Do not pass `--update`, `--update-input`, or otherwise update flake inputs unless the task explicitly requires an input update.

These operations can modify `flake.lock`.

When running an operation that may modify repository files, preserve unrelated existing changes.

## Search packages and options

Use an explicit search mode when the target is known:

```sh
nh search packages ripgrep

nh search options networking.hostName --scope nixpkgs

nh search options programs.zsh.enable --scope home-manager

nh search options system.defaults --scope nix-darwin
```

Available option scopes include:

- `nixpkgs`
- `home-manager`
- `nix-darwin`
- `all`

`nh search <query>` searches packages by default unless configured otherwise.

Other search modes include:

```sh
nh search offline <query>
nh search prs <query>
nh search issues <query>
```

Consult local help for version-specific arguments such as offline database paths, channels, platforms, result limits, and authentication.

If search results do not correspond to the configuration being edited, verify the selected channel and option scope.

## Clean profiles and the Nix store

`nh clean` can remove old profile generations, gcroots, and unreferenced Nix store paths.

Run cleanup only when the user asks for cleanup or when another explicit task requires it.

Inspect local help before choosing a cleanup scope:

```sh
nh clean --help
nh clean user --help
nh clean profile --help
nh clean all --help
```

Prefer a dry run before destructive cleanup when supported:

```sh
nh clean user --dry
```

Choose the cleanup scope that matches the request.

Be aware of these controls:

- `--no-gcroots` skips gcroot cleanup.
- `--no-direnv` preserves direnv gcroots while other selected gcroots may still be cleaned.
- `--no-gc` skips Nix store garbage collection.

These options do not imply that profile generation cleanup is skipped.

Review the proposed cleanup before executing it.
