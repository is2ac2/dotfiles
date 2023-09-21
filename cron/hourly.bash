#!/usr/bin/env bash

# For Python
source ~/.shell/aliases.sh
source ~/.bash/aliases.bash

load-brew

# Ensures that scripts folders are only executable by user.
[ -d ~/scripts ] && chmod -R 744 ~/scripts
[ -d ~/.scripts ] && chmod -R 744 ~/.scripts
[ -d ~/.tmp-scripts ] && chmod -R 744 ~/.tmp-scripts

# Sweeps dates files.
/bin/bash ~/.cron/sweep_dates.bash

# Caches running slurm jobs.
python3 ~/.scripts/slurm-parse-comment

# Runs local cron script, if found.
if [ -f ~/.cron-local/hourly.bash ]; then
    /bin/bash ~/.cron-local/hourly.bash
fi

