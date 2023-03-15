# -----------------------------------------------
# Prints value of an environment variable by name
# -----------------------------------------------

env-val() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: env-val <var>"
        return 1
    fi
    local var=$1
    echo ${!var}
}

# -----
# Slurm
# -----

scancelme() {
    read -p "Really cancel all your runs? [N/y] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
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
    unalias conda 2> /dev/null

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('${CONDA_DIR}/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "${CONDA_DIR}/etc/profile.d/conda.sh" ]; then
            . "${CONDA_DIR}/etc/profile.d/conda.sh"
        else
            export PATH="${CONDA_DIR}/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
}

alias conda='load-conda && \conda'
