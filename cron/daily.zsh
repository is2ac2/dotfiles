#!/bin/zsh

# For "get-storage"
source ~/.shell/aliases.sh

# Updates old dates.
~/.cron/manage_date_folders.zsh

# Runs local cron script, if found.
if [[ -f ~/.cron-local/daily.zsh ]]; then
    ~/.cron-local/daily.zsh
fi

# Computes storage space (put this last because it might be slow).
cd ~ && get-storage ~/storage
