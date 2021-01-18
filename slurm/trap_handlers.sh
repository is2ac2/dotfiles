#!/bin/sh
#
# Usage:
#   source ${HOME}/.slurm/trap_handlers.sh
#
# Use these commands to set the relevant trap handlers before the `srun` command,
# to handle user terminations.

trap_handler () {
    echo "Caught signal: " $1
    if [ "$1" = "TERM" ]; then
        echo "bypass sigterm"
    else
        echo "Requeuing " $SLURM_JOB_ID
        scontrol requeue $SLURM_JOB_ID
    fi
}

trap 'trap_handler USR1' USR1
trap 'trap_handler TERM' TERM
