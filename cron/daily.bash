#!/bin/bash

# Sources bashrc to make sure Python is set correctly.
source ${HOME}/.shell/aliases.sh
source ${HOME}/.shell/tools.sh

# Updates old dates.
${HOME}/.cron/manage_date_folders.bash

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/daily.bash ]; then
    . ${HOME}/.cron-local/daily.bash
fi
