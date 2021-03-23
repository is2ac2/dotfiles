#!/bin/sh

start_date=$(date --date '90 days ago' +'%Y-%m-%d')
end_date=$(date --date '30 days ago' +'%Y-%m-%d')

# Deletes logs older than 30 days.
python3 /home/bbolte/.scripts/manage_dates \
    ~/logs/ \
    -s $start_date \
    -e $end_date \
    -a delete

# Deletes eval older than 30 days.
python3 /home/bbolte/.scripts/manage_dates \
    ~/eval/ \
    -s $start_date \
    -e $end_date \
    -a delete

