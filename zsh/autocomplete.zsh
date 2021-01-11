# conda
_cenv() {
    local opts
    opts=$(cat ~/.conda/environments.txt | xargs -L1 basename | tr '\n' ' ')
    compadd ${=opts}
}
cenv() {
    conda activate $@
}
if [[ -f ~/.conda/environments.txt ]]; then
    compdef _cenv cenv
fi

# tmux
tmuxc() {
    tmux -CC a -t $@
}
_tmuxc() {
    local opts
    opts="$(tmux list-sessions -F '#S' | tr '\n' ' ')"
    compadd ${=opts}
}
compdef _tmuxc tmuxc

