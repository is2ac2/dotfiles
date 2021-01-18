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
