# -----
# conda
# -----

alias cn-env='conda activate'
_conda_complete() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="$(cat ~/.conda/environments.txt | xargs -L1 basename | paste -sd ' ')"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
if [[ -f ~/.conda/environments.txt ]]; then
    complete -F _conda_complete 'cn-env'
fi

_cn_vars_complete() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="rm rm-activate rm-deactivate activate deactivate"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _cn_vars_complete 'cn-vars'

# ----
# tmux
# ----

alias tmuxc='tmux -CC a -t'
alias tmuxa='tmux a -dt'
_tmux_complete(){
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="$(tmux list-sessions -F '#S' | paste -sd ' ')"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _tmux_complete tmuxc
complete -F _tmux_complete tmuxn
complete -F _tmux_complete tmuxa
complete -F _tmux_complete tmuxd

# -----------
# tmp-scripts
# -----------

_tcomplete() {
    local cur opts

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="$(find $TMP_SCRIPT_ROOT -type f | cut -c${#TMP_SCRIPT_ROOT}- | sed 's:/*::' | paste -sd " " -)"

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _tcomplete tedit
complete -F _tcomplete trun
complete -F _tcomplete tdelete
