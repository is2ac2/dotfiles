# .bashrc

if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

if [ -f ~/.bashrc_local_before ]; then
    source ~/.bashrc_local_before
fi

source ~/.shell/info.sh
source ~/.shell/aliases.sh
source ~/.bash/autocomplete.bash
source ~/.bash/settings.bash
source ~/.bash/prompt.bash

if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

if [ -f ~/.bashrc_local_after ]; then
    source ~/.bashrc_local_after
fi
