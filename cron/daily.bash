#!/usr/bin/env bash

# For "get-storage"
source ~/.shell/aliases.sh

# Updates old dates.
$SHELL ~/.cron/manage_date_folders.zsh

# Runs local cron script, if found.
if [[ -f ~/.cron-local/daily.bash ]]; then
    $SHELL ~/.cron-local/daily.bash
fi

# Computes storage space (put this last because it might be slow).
cd ~ && get-storage ~/storage
