# .zshrc

if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

if [ -f ~/.zshrc_local_before ]; then
    source ~/.zshrc_local_before
fi

source ~/.zsh/plugins_before.zsh
source ~/.shell/info.sh
source ~/.shell/aliases.sh
source ~/.zsh/aliases.zsh
source ~/.zsh/autocomplete.zsh
source ~/.zsh/settings.zsh
source ~/.zsh/plugins_after.zsh

if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

if [ -f ~/.zshrc_local_after ]; then
    source ~/.zshrc_local_after
fi
