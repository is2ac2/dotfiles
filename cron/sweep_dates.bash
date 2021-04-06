#!/bin/bash

# Sweeps dates in log directory.
if [ -d $LOG_DIR ]; then
    python3 ${HOME}/.scripts/manage_dates $LOG_DIR -a sweep
else
    echo "Missing log directory: $LOG_DIR"
fi

# Sweep dates in eval directory.
if [ -d $EVAL_DIR ]; then
    python3 ${HOME}/.scripts/manage_dates $EVAL_DIR -a sweep
else
    echo "Missing eval directory: $EVAL_DIR"
fi

