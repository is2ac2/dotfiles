#!/bin/sh

# Adds script directories
pathadd PATH ${HOME}/.scripts
pathadd PATH ${HOME}/.scripts-local > /dev/null

# Golang
export GOPATH=${HOME}/.go

# Cleans up paths
pathclean PATH
