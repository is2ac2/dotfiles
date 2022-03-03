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
