#! /bin/sh

if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" \
        --keep-zshrc \
        --unattended
fi
