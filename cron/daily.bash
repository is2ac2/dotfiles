#!/bin/bash

# Sources bashrc to make sure Python is set correctly.
source ${HOME}/.shell/aliases.sh

# Updates old dates.
${HOME}/.cron/manage_date_folders.bash

# Cleans up old folders.
${HOME}/.cron/cleanup.bash

# Computes storage space.
cd ${HOME} && du -h -d 4 | sort -h > ${HOME}/storage

