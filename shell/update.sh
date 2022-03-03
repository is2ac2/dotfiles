#!/bin/sh

local old_dir=$(pwd)

cd ${HOME}/.dotfiles

if [[ $(git status --porcelain) ]]; then
    echo -e "\033[1;31m----- Uncommitted Dotfile changes -----\033[0m"
else
    git pull origin master 1> /dev/null
fi

cd ${old_dir}

