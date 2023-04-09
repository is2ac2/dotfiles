#!/bin/bash

# For `get-storage`
source ${HOME}/.bashrc

# Updates old dates.
${HOME}/.cron/manage_date_folders.bash

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/daily.bash ]; then
    . ${HOME}/.cron-local/daily.bash
fi

# Computes storage space (put this last because it might be slow).
cd ${HOME} && get-storage ${HOME}/storage
