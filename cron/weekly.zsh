#!/bin/zsh

# For Python
source ~/.shell/aliases.sh
source ~/.zsh/aliases.zsh

load-brew

# Runs local cron script, if found.
if [ -f ~/.cron-local/weekly.zsh ]; then
    . ~/.cron-local/weekly.zsh
fi
