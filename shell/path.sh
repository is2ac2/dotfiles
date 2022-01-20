#!/bin/sh

export PATH=$PATH:${HOME}/.scripts
if [ -d ${HOME}/.scripts-local ]; then
    export PATH=${PATH}:${HOME}/.scripts-local
fi

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"

