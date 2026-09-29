fish_add_path ~/.local/bin
fish_add_path ~/.bun/bin
zoxide init fish | source
set fish_greeting ""
fish_vi_key_bindings
direnv hook fish | source
