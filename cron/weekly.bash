#!/bin/bash

# Sources bashrc to make sure Python is set correctly.
source ${HOME}/.shell/aliases.sh
source ${HOME}/.shell/tools.sh

# Cleans up old folders.
${HOME}/.cron/cleanup.bash

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/weekly.bash ]; then
    . ${HOME}/.cron-local/weekly.bash
fi

# Computes storage space (put this last because it might be slow).
cd ${HOME} && get-storage ${HOME}/storage