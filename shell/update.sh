#!/bin/sh

pull_dotfiles() {
    local old_dir=$(pwd)
    cd ${HOME}/.dotfiles
    if [[ $(git status --porcelain) ]]; then
        echo -e "\033[1;31m----- Uncommitted Dotfile changes -----\033[0m"
    else
        git pull origin master --quiet
    fi
    cd ${old_dir}
}

pull_dotfiles

