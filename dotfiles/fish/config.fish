fish_add_path ~/.local/bin
fish_add_path ~/.bun/bin
set fish_greeting ""
fish_vi_key_bindings
mise activate fish | source
direnv hook fish | source
starship init fish | source
zoxide init fish | source
