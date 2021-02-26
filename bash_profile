# .bash_profile is executed by login shells before the command prompt is shown,
# whereas .bashrc is loaded by new windows after having already logged in.
# For remote development, this means it's better to use TMUX for doing
# local development, and avoid putting anything heavy in the .bash_profile file
# so that other connections aren't slowed down.

source ~/.shell/info.sh
source ~/.shell/aliases.sh
source ~/.shell/tools.sh
source ~/.bash/aliases.bash
source ~/.bash/autocomplete.bash
source ~/.bash/settings.bash
source ~/.bash/prompt.bash
