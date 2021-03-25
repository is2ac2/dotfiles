#!/bin/sh

# Get date range, handling different operating systems.
case $OSTYPE in
    "darwin"*)
        start_date=$(date -v-90d +'%Y-%m-%d')
        end_date=$(date -v-30d +'%Y-%m-%d')
        ;;
    "linux-gnu"*)
        start_date=$(date --date '90 days ago' +'%Y-%m-%d')
        end_date=$(date --date '30 days ago' +'%Y-%m-%d')
        ;;
    *)
        echo "OS type not supported: $OSTYPE"
        return
        ;;
esac

# Deletes logs older than 30 days.
if [[ -d ${HOME}/logs ]]; then
    python3 ${HOME}/.scripts/manage_dates \
        ${HOME}/logs/ \
        -s $start_date \
        -e $end_date \
        -a delete
fi

# Deletes eval older than 30 days.
if [[ -d ${HOME}/eval ]]; then
    python3 ${HOME}/.scripts/manage_dates \
        ${HOME}/eval/ \
        -s $start_date \
        -e $end_date \
        -a delete
fi

