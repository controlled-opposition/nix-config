# Keep PATH entries unique, with user-installed tools first.
typeset -U path PATH
path=("$HOME/.bun/bin" "$HOME/.local/bin" $path)
export PATH

eval "$(zoxide init zsh)"
bindkey -v
eval "$(direnv hook zsh)"
