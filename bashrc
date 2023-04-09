# .bashrc

# ---------------------------------
# Return for non-interactive shells
# ---------------------------------

if [ -z "$PS1" ]; then
    return
fi

# ------------------
# Main Bash commands
# ------------------

if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

if [ -f ~/.bashrc_local_before ]; then
    source ~/.bashrc_local_before
fi

source ~/.bash/aliases.bash
source ~/.bash/autocomplete.bash
source ~/.bash/settings.bash
source ~/.bash/prompt.bash

source ~/.shell/update.sh
source ~/.shell/info.sh
source ~/.shell/aliases.sh

if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

if [ -f ~/.bashrc_local_after ]; then
    source ~/.bashrc_local_after
fi

source ~/.shell/path.sh
