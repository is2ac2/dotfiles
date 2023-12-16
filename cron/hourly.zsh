#!/bin/zsh

# For Python
source ~/.shell/aliases.sh
source ~/.zsh/aliases.zsh

load-brew

# Ensures that scripts folders are only executable by user.
[ -d ~/scripts ] && chmod -R 744 ~/scripts
[ -d ~/.scripts ] && chmod -R 744 ~/.scripts
[ -d ~/.tmp-scripts ] && chmod -R 744 ~/.tmp-scripts

# Sweeps dates files.
~/.cron/sweep_dates.zsh

# Runs local cron script, if found.
if [ -f ~/.cron-local/hourly.zsh ]; then
    ~/.cron-local/hourly.zsh
fi
