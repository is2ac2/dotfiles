#!/bin/bash

warn-big-text() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: warn-big-text <text>"
    else
        local text="WARNING: $1"; shift
        printf '%*s\n' "${#text}" '' | tr ' ' '!'
        printf "${RED}${text}${NC}\n"
        printf '%*s\n' "${#text}" '' | tr ' ' '!'
    fi
}

pull-dotfiles() {
    local old_dir=$(pwd)
    cd ${HOME}/.dotfiles
    if [[ $(git status --porcelain) ]]; then
        warn-big-text 'Uncommitted Dotfile changes'
    else
        git sync > /dev/null 2> /dev/null
    fi
    cd ${old_dir}
}

(pull-dotfiles &)
