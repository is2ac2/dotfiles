#!/bin/zsh

# For Python
source ~/.shell/aliases.sh
source ~/.zsh/aliases.zsh

load-brew

# Cleans up old folders.
/bin/zsh ~/.cron/cleanup.zsh

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/weekly.bash ]; then
    . ${HOME}/.cron-local/weekly.bash
fi
