#!/bin/bash

# Sources bashrc to make sure Python is set correctly.
source ${HOME}/.shell/aliases.sh

# Updates old dates.
${HOME}/.cron/manage_date_folders.bash

# Cleans up old folders.
${HOME}/.cron/cleanup.bash

# Computes storage space.
cd ${HOME} && df -h 2> /tmp/df.err > ${HOME}/storage
cd ${HOME} && du -h -d 4 2> /tmp/du.err | sort -r -h >> ${HOME}/storage

# Runs local cron script, if found.
if [ -f ${HOME}/.cron-local/daily.bash ]; then
    . ${HOME}/.cron-local/daily.bash
fi

