#!/bin/sh

# Adds script directories
pathadd PATH ${HOME}/.scripts
pathadd PATH ${HOME}/.scripts-local > /dev/null

# Cleans up paths
pathclean PATH

