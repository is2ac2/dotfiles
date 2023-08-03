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
