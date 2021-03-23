#!/bin/sh

# Sources bashrc to make sure Python is set correctly.
if [[ -f ${HOME}/.bashrc ]]; then
    source ${HOME}/.bashrc
fi

# Removes empty log directories.
find ${HOME}/logs -maxdepth 2 -empty -type d -mtime +1 -exec rm -r {} \;

# Updates daily symlinks.
/bin/sh update_symlinks.sh

# Updates old dates.
/bin/sh delete_old_dates.sh

# Removes old slurm log directories.
[ -d "${HOME}/slurm_logs"  ] && find $HOME/slurm_logs/* -type d -mtime +45 | xargs -I {} -P 8 rm -r {} \;

# Removes old run directories.
[ -d "${HOME}/runs"  ] && find $HOME/runs/* -type d -mtime +45 | xargs -I {} -P 8 rm -r {} \;

# Runs local cron script, if found.
if [[ -f ${HOME}/.cron-local/daily.sh ]]; then
    source ${HOME}/.cron-local/daily.sh
fi

