#!/bin/bash

# Sources bashrc to make sure Python is set correctly.
source ${HOME}/.shell/aliases.sh
source ${HOME}/.shell/tools.sh

# Updates old dates.
${HOME}/.cron/manage_date_folders.bash

# Cleans up old folders.
${HOME}/.cron/cleanup.bash

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/daily.bash ]; then
    . ${HOME}/.cron-local/daily.bash
fi

# Computes storage space (put this last because it might be slow).
cd ${HOME} && get-storage ${HOME}/storage

