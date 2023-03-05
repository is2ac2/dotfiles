# -----------------------------------------------
# Prints value of an environment variable by name
# -----------------------------------------------

env-val() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: env-val <var>"
        return 1
    fi
    local var=${1//[^a-zA-Z_]/}
    eval "echo \$${var}"
}

# -----
# Slurm
# -----

scancelme() {
    read "reply?Really cancel all your runs? [N/y] "
    echo
    if [[ $reply =~ ^[Yy]$ ]]; then
        echo "Cancelling all runs for $USER"
        scancel -u $USER
    else
        echo "Aborting"
    fi
}

# -----
# Conda
# -----

load-conda() {
    # >>> conda initialize >>>
    __conda_setup="$('${CONDA_DIR}/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "${CONDA_DIR}/etc/profile.d/conda.sh" ]; then
            . "${CONDA_DIR}/etc/profile.d/conda.sh"
        else
            pathadd PATH "${CONDA_DIR}/bin"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
}
