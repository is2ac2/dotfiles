#!/bin/bash

# Sources bashrc to make sure Python is set correctly.
source ${HOME}/.bashrc

# Ensures that scripts folders are only executable by user.
[ -d "${HOME}/scripts"  ] && chmod -R 744 ${HOME}/scripts
[ -d "${HOME}/.scripts"  ] && chmod -R 744 ${HOME}/.scripts
[ -d "${HOME}/.tmp-scripts" ] && chmod -R 744 ${HOME}/.tmp-scripts

# Sweeps dates files.
${HOME}/.cron/sweep_dates.bash

# Caches running slurm jobs.
${HOME}/.scripts/slurm-parse-comment

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/hourly.bash ]; then
    . ${HOME}/.cron-local/hourly.bash
fi

