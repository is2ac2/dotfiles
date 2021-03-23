#!/bin/sh

# Sources bashrc to make sure Python is set correctly.
if [[ -f ${HOME}/.bashrc ]]; then
    source ${HOME}/.bashrc
fi

# Ensures that scripts folders are only executable by user.
[ -d "${HOME}/scripts"  ] && chmod -R 744 $HOME/scripts
[ -d "${HOME}/.scripts"  ] && chmod -R 744 $HOME/.scripts

# Sweeps dates files.
/bin/sh ${HOME}/.cron/sweep_dates.sh

# Runs local cron script, if found.
if [[ -f ${HOME}/.cron-local/hourly.sh ]]; then
    source ${HOME}/.cron-local/hourly.sh
fi

