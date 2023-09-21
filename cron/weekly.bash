#!/usr/bin/env bash

# For Python
source ~/.shell/aliases.sh
source ~/.bash/aliases.bash

load-brew

# Cleans up old folders.
/usr/bin/env bash ~/.cron/cleanup.bash

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/weekly.bash ]; then
    . ${HOME}/.cron-local/weekly.bash
fi
