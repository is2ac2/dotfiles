# -----
# conda
# -----

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

_cvars() {
    compadd rm rm-activate rm-deactivate activate deactivate
}
compdef _cvars cvars

# ----
# tmux
# ----

tmuxc() {
    tmux -CC a -t $@
}
_tmux() {
    local opts
    opts="$(tmux list-sessions -F '#S' | tr '\n' ' ')"
    compadd ${=opts}
}
compdef _tmux tmuxc
compdef _tmux tmuxn

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
