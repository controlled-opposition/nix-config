# Repository instructions

## Edit

- Preserve unrelated working-tree changes.
- Keep machine settings in `hosts/<name>/` and user settings in `home/<user>/`.
- Name host directories after exported configuration keys and user directories after `hjem.users` keys.
- Assemble features and users in each host's `default.nix`, not `flake.nix`.
- Put shared system modules in `modules/system/`, NixOS-only modules in `modules/nixos/`, and Hjem modules in `modules/hjem/`. Import modules explicitly.
- Use two-space indentation. Keep modules small. Group related options under namespaces such as `programs`, `services`, and `environment`.
- Keep Stow and Hjem file ownership separate. Manage Pi's `settings.json` with Stow. Keep credentials, sessions, and downloaded packages machine-local.
- Add Pi extensions only when requested.
- Update dependency pins with `nix flake update`.
- Keep documentation minimal. Link to configuration files instead of copying option or shortcut lists.

## Validate

Format changed Nix files with `nixfmt`. Evaluate each affected host with the [README commands](./README.md#check-changes).
There is no separate test suite.

Activate only on the matching machine. Review the activation output for errors.

## Commit and review

Use short, lower-case, imperative commit subjects, such as `add chaotic nyx`. Keep commits focused.

In pull requests, name the affected hosts and users. Summarize behavior and pin changes. List evaluation or rebuild commands.
Add screenshots only for visible desktop, editor, or wallpaper changes.
