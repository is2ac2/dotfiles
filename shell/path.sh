#!/bin/sh

# Adds script directories
pathadd PATH ${HOME}/.scripts
pathadd PATH ${HOME}/.scripts-local > /dev/null

# Added by Amplify CLI binary installer
pathadd PATH $HOME/.amplify/bin > /dev/null

# Cleans up paths
pathclean PATH

