#!/bin/bash

warn-with-red-background() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: warn-big-text <text>"
    else
        local text="WARNING: $1"; shift

        # Red text.
        # local red='\033[0;31m'
        # local nc='\033[0m'
        # echo -e "${red}${text}${nc}"

        # Red background.
        local red='\033[41m'
        local nc='\033[0m'
        echo -e "${red}${text}${nc}"
    fi
}

pull-dotfiles() {
    local old_dir=$(pwd)
    cd ${HOME}/.dotfiles
    if [[ $(git status --porcelain) ]]; then
        warn-with-red-background 'Uncommitted Dotfile changes'
    else
        git sync > /dev/null 2> /dev/null
    fi
    cd ${old_dir}
}

if [ -t 1  ] ; then
    (pull-dotfiles &)
fi
