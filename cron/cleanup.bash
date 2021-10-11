#!/bin/bash

# Sources bashrc to make sure Python is set correctly.
source ${HOME}/.shell/aliases.sh

# Removes old slurm log directories.
if [ -d "$SLURM_LOG_DIR" ]; then
    find "$SLURM_LOG_DIR/" \
        -mindepth 1 \
        -type f \
        -mtime +7 | xargs -I {} -P 8 rm -r {} 2> /tmp/${USER}_slurm_cleanup_$(date +'%Y-%m-%d').log
else
    echo "Missing slurm log directory: '$SLURM_LOG_DIR'"
fi

# Removes old run directories.
if [ -d "$RUN_DIR" ]; then
    find "$RUN_DIR/" \
        -mindepth 1 \
        -type d \
        -mtime +14 | xargs -I {} -P 8 rm -r {} 2> /tmp/${USER}_run_cleanup_$(date +'%Y-%m-%d').log
else
    echo "Missing run directory: '$RUN_DIR'"
fi

# Removes empty log directories.
if [ -d "$LOG_DIR" ]; then
    find "$LOG_DIR/" \
        -mindepth 1 \
        -maxdepth 2 \
        -empty \
        -type d \
        -mtime +2 | xargs -I {} -P 8 rm -r {} 2> /tmp/${USER}_log_cleanup_$(date +'%Y-%m-%d').log
    find "$LOG_DIR/" \
        -mindepth 1 \
        -maxdepth 2 \
        -name local.* \
        -type d \
        -mtime +1 | xargs -I {} -P 8 rm -r {} 2> /tmp/${USER}_local_cleanup_$(date +'%Y-%m-%d').log
else
    echo "Missing log directory: '$LOG_DIR'"
fi

# Removes empty eval directories.
if [ -d "$EVAL_DIR" ]; then
    find "$EVAL_DIR/" \
        -mindepth 1 \
        -maxdepth 2 \
        -empty \
        -type d \
        -mtime +2 | xargs -I {} -P 8 rm -r {} 2> /tmp/${USER}_eval_cleanup_$(date +'%Y-%m-%d').log
else
    echo "Missing eval directory: '$EVAL_DIR'"
fi

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/daily.bash ]; then
    . ${HOME}/.cron-local/daily.bash
fi
