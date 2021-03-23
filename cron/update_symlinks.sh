#!/bin/bash

set -e

today=$(date +"%Y-%m-%d")

logs_today=${HOME}/logs/$today
eval_today=${HOME}/eval/$today

mkdir -p $logs_today
mkdir -p $eval_today

# Updates log directory for today.
if [[ -L ${HOME}/logs/today ]]; then
    unlink ${HOME}/logs/today
fi
ln -s $logs_today ${HOME}/logs/today

# Update eval directory for today.
if [[ -L ${HOME}/eval/today ]]; then
    unlink ${HOME}/eval/today
fi
ln -s $eval_today ${HOME}/eval/today

