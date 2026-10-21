# Apply the zsh migration

zsh is no longer configured by Home Manager. The shell config lives in [`dotfiles/zsh/zshrc`](../dotfiles/zsh/zshrc) and is linked to `~/.zshrc` by mise. Plugins are managed by sheldon from [`dotfiles/sheldon/plugins.toml`](../dotfiles/sheldon/plugins.toml). Home Manager and nix-darwin still install the executables.

Apply these steps on each machine after it has this commit. Run every command from the repository root on the matching machine. Never run another machine's commands.

## rubus (weasel)

```sh
sudo nix run --inputs-from . nixpkgs#nixos-rebuild -- switch --flake .#rubus
nix run --inputs-from . home-manager -- switch --flake '.#weasel@rubus' -b backup
mise trust ./mise.toml
mise bootstrap dotfiles apply --dry-run
mise bootstrap dotfiles apply
mise bootstrap dotfiles status
```

## malus (everick)

```sh
sudo nix run --inputs-from . nix-darwin -- switch --flake .#malus
nix run --inputs-from . home-manager -- switch --flake '.#everick@malus' -b backup
mise trust ./mise.toml
mise bootstrap dotfiles apply --dry-run
mise bootstrap dotfiles apply
mise bootstrap dotfiles status
```

## Notes

- If the dry run reports a conflict for `~/.zshrc` or `~/.config/sheldon/plugins.toml`, back up the existing file and apply again. Do not use `--force`.
- The first new shell downloads the sheldon plugins, so it needs network access.
