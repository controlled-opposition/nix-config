---
name: nh
description: Use the nh CLI to build or activate NixOS, nix-darwin, and Home Manager configurations, search packages and options, or clean Nix generations and store paths. Load when a task involves nh commands.
---

# Use nh

`nh` wraps Nix configuration, search, and cleanup commands. Check the installed version and command help before using flags you have not verified. Flags can vary between releases.

```sh
nh --version
nh --help
nh os switch --help
```

## Choose a configuration command

Pass the flake directory explicitly. Use `.` when you are in the flake root. Select the command group for the configuration type:

```sh
nh os build . -H <hostname>
nh os test . -H <hostname>
nh os switch . -H <hostname>
nh darwin build . -H <hostname>
nh darwin switch . -H <hostname>
nh home build . -c <username@hostname>
nh home switch . -c <username@hostname>
```

`build` builds without activating. `nh os test` activates the NixOS configuration without making it the boot default. `nh os switch` activates it and makes it the boot default. `nh home switch` and `nh darwin switch` activate their configurations.

Use the exact hostname or Home Manager configuration name exported by the selected flake. Inspect the flake or its documentation to identify valid names. If Home Manager is integrated with a NixOS or nix-darwin configuration, check whether system activation already applies it before running a separate `nh home switch`.

Build first when validating a configuration change. Activate only when the user requests activation and you are on the matching machine. Do not prefix commands with `sudo`; let `nh` use its configured elevation strategy. Check the activation output for errors.

Do not pass `--update` or `--update-input` unless the user requests a flake input update. These options change the lock file. Check `git status` before a command that may write files and preserve existing changes.

## Search packages and options

Use explicit search modes when you know what you need:

```sh
nh search packages ripgrep
nh search options networking.hostName --scope nixpkgs
nh search options programs.zsh.enable --scope home-manager
```

Use `nh search --help` and the relevant subcommand's help for other modes, including offline database, Nixpkgs pull request, or issue searches. Check the channel and option scope when results do not match the flake you are working with. See the [nh upstream README](https://github.com/nix-community/nh) for general documentation; prefer local help for version-specific flags.

## Clean profiles and the Nix store

Cleanup removes generations or garbage-collection roots, and store garbage collection can delete paths no longer reachable from roots. Inspect the installed defaults before cleanup:

```sh
nh clean user --help
nh clean user --dry
```

Run cleanup only when the user asks for it. Choose `user`, `profile`, or `all` to match the requested scope. Review the dry-run output and retention options before executing cleanup. `--no-gcroots` skips gcroot cleanup; it does not skip generation cleanup or Nix store garbage collection. `--no-gc` skips store garbage collection but does not preserve profiles or gcroots selected for cleanup. Use `--no-direnv` to preserve direnv gcroots.
