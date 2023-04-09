#!/bin/sh

# conda
if [[ -f ${HOME}/.conda/environments.txt ]] && [[ ! -z $(grep '[^[:space:]]' "${HOME}/.conda/environments.txt")  ]]; then
    cat ${HOME}/.conda/environments.txt | sort | while read line; do echo -n -e "[\033[1;32m$(basename $line)\033[0m] "; done
    echo -n -e "\n"
fi
