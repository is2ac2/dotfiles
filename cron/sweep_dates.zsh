#!/bin/zsh

# Sources aliases to make sure Python is set correctly.
source ~/.shell/aliases.sh

# Sweeps dates in log directory.
if [ -n $LOG_DIR ] && [ -d $LOG_DIR ]; then
    python3 ~/.scripts/manage_dates -a sweep $LOG_DIR
else
    echo "Missing log directory: $LOG_DIR"
fi

# Sweep dates in eval directory.
if [ -n $EVAL_DIR ] && [ -d $EVAL_DIR ]; then
    python3 ~/.scripts/manage_dates -a sweep $EVAL_DIR
else
    echo "Missing eval directory: $EVAL_DIR"
fi
