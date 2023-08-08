# -----
# conda
# -----

_conda_complete() {
    local opts
    opts=$(cat ~/.conda/environments.txt | xargs -L1 basename | tr '\n' ' ')
    compadd ${=opts}
}
cn-env() {
    micromamba activate $@
}
cn-rm() {
    if [[ "$CONDA_DEFAULT_ENV" -eq "$1" ]]; then
        conda deactivate
    fi
    conda remove --all --name $1
}
if [[ -f ~/.conda/environments.txt ]]; then
    compdef _conda_complete cn-env
    compdef _conda_complete cn-rm
fi

_conda_vars() {
    compadd rm rm-activate rm-deactivate activate deactivate
}
compdef _conda_vars cn-vars

# ----
# tmux
# ----

tmuxc() {
    tmux -CC a -t $@
}
tmuxa() {
    tmux a -dt $@
}
_tmux() {
    local opts
    opts="$(tmux list-sessions -F '#S' | tr '\n' ' ')"
    compadd ${=opts}
}
compdef _tmux tmuxc
compdef _tmux tmuxn
compdef _tmux tmuxa
compdef _tmux tmuxd

# -----------
# tmp-scripts
# -----------

_tcomplete() {
    local opts
    opts="$(find $TMP_SCRIPT_ROOT -type f | cut -c${#TMP_SCRIPT_ROOT}- | sed 's:/*::' | paste -sd " " -)"
    compadd ${=opts}
}
compdef _tcomplete tedit
compdef _tcomplete trun
compdef _tcomplete tdelete
