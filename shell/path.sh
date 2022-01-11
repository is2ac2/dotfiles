#!/bin/sh

export PATH=$PATH:${HOME}/.scripts
if [ -d ${HOME}/.scripts-local ]; then
    export PATH=${PATH}:${HOME}/.scripts-local
fi
