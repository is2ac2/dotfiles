#!/bin/bash

# Sources bashrc to make sure Python is set correctly.
if [ -f ${HOME}/.bashrc ]; then
    . ${HOME}/.bashrc
fi

# Updates old dates.
${HOME}/.cron/manage_date_folders.bash

# Removes old slurm log directories.
[ -d "$SLURM_DIR" ] && find $SLURM_DIR -type d -mtime +45 | xargs -I {} -P 8 rm -r {}

# Removes old run directories.
[ -d "$RUN_DIR" ] && find $RUN_DIR -type d -mtime +45 | xargs -I {} -P 8 rm -r {}

# Removes empty log directories.
[ -d "$LOG_DIR" ] && find $LOG_DIR -maxdepth 2 -empty -type d -mtime +2 | xargs -I {} -P 8 rm -r {}

# Removes old local runs.
[ -d "$LOG_DIR" ] && find $LOG_DIR -maxdepth 2 -name local.* -type d -mtime +1 | xargs -I {} -P 8 rm -r {}

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/daily.bash ]; then
    . ${HOME}/.cron-local/daily.bash
fi

