# -----
# conda
# -----

_conda_complete() {
    local opts
    opts=$(cat ~/.conda/environments.txt | xargs -L1 basename | tr '\n' ' ')
    compadd ${=opts}
}

cn-env() {
    conda activate $@
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

# --
# uv
# --

_uv_complete() {
    local opts
    opts=$(ls -1 ${UV_ENV_ROOT} | tr '\n' ' ')
    compadd ${=opts}
}

uv-env() {
    source ${UV_ENV_ROOT}/$1/bin/activate
}

uv-rm() {
    if [[ "$UV_DEFAULT_ENV" -eq "$1" ]]; then
        deactivate
    fi
    rm -rf ${UV_ENV_ROOT}/$1
}

if [[ -d ${UV_ENV_ROOT} ]]; then
    compdef _uv_complete uv-env
    compdef _uv_complete uv-rm
fi

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
