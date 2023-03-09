# .zshrc

# ---------------------------------
# Return for non-interactive shells
# ---------------------------------

if [ -z "$PS1" ]; then
    return
fi

# ---------
# oh-my-zsh
# ---------

export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="amuse"

export CASE_SENSITIVE=true
export DISABLE_UPDATE_PROMPT=true
export ZSH_DISABLE_COMPFIX=true

plugins=(git)

source $ZSH/oh-my-zsh.sh

# -----------
# Main config
# -----------

if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

if [ -f ~/.zshrc_local_before ]; then
    source ~/.zshrc_local_before
fi

source ~/.zsh/plugins_before.zsh
source ~/.shell/update.sh
source ~/.shell/info.sh
source ~/.shell/aliases.sh
source ~/.zsh/aliases.zsh
source ~/.zsh/settings.zsh
source ~/.zsh/autocomplete.zsh
source ~/.zsh/plugins_after.zsh

if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

if [ -f ~/.zshrc_local_after ]; then
    source ~/.zshrc_local_after
fi

source ~/.shell/path.sh
