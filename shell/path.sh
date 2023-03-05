#!/bin/sh

# Adds script directories
pathadd PATH ${HOME}/.scripts
pathadd PATH ${HOME}/.scripts-local > /dev/null

# Adds Homebrew.
pathadd PATH /opt/homebrew/bin > /dev/null

# Golang
export GOPATH=${HOME}/.go

# Cleans up paths
pathclean PATH
