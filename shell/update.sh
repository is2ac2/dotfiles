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
        git pull --quiet
    fi
    cd ${old_dir}
}

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0  ]; then
    pull_dotfiles
else
    warn-big-text 'No internet access'
fi

