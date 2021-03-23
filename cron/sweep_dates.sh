#!/bin/bash

# Sweeps dates in these directories.
if [[ -d ${HOME}/logs ]]; then
    python3 ${HOME}/.scripts/manage_dates ${HOME}/logs/ -a sweep
fi

if [[ -d ${HOME}/eval ]]; then
    python3 ${HOME}/.scripts/manage_dates ${HOME}/eval/ -a sweep
fi

