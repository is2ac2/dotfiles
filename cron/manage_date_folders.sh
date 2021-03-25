#!/bin/bash

set -e

today=$(date +"%Y-%m-%d")

# Get date range, handling different operating systems.
case $OSTYPE in
    "darwin"*)
        start_date=$(date -v-90d +'%Y-%m-%d')
        end_date=$(date -v-30d +'%Y-%m-%d')
        yesterday=$(date -v-1d +'%Y-%m-%d')
        ;;
    "linux-gnu"*)
        start_date=$(date --date '90 days ago' +'%Y-%m-%d')
        end_date=$(date --date '30 days ago' +'%Y-%m-%d')
        yesterday=$(date --date '1 day ago' +'%Y-%m-%d')
        ;;
    *)
        echo "OS type not supported: $OSTYPE"
        return
        ;;
esac

# Deletes any date folders older than 30 days.
__delete_old_dates() {
    root=$1

    python3 ${HOME}/.scripts/manage_dates \
        ${HOME}/logs/ \
        -s $start_date \
        -e $end_date \
        -a delete
}

# Updates the daily symlink to point to today.
__update_symlinks() {
    root=$1
    root_today=$root/$today
    root_yesterday=$root/$yesterday
    mkdir -p $root_today

    # Updates directory for today.
    if [ -L $root/today ]; then
        unlink $root/today
    fi
    ln -s $root_today $root/today

    # Updates directory for yesterday.
    if [ -L $root/yesterday ]; then
        unlink $root/yesterday
    fi
    ln -s $root_yesterday $root/yesterday

    return 0
}

manage_date_folders() {
    if [ $# -ne 1 ]; then
        echo "Usage: update_symlinks <root>"
    fi
    root=$1
    shift
    if ! [ -d $root ]; then
        return 0
    fi

    __update_symlinks $root
    __delete_old_dates $root
}

manage_date_folders ${HOME}/logs
manage_date_folders ${HOME}/eval

