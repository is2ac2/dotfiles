#!/bin/sh

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

pull_dotfiles() {
    local old_dir=$(pwd)
    cd ${HOME}/.dotfiles
    if [[ $(git status --porcelain) ]]; then
        warn-big-text 'Uncommitted Dotfile changes'
    else
        git pull origin master --quiet
    fi
    cd ${old_dir}
}

pull_dotfiles

