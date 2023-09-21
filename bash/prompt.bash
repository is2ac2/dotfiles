ATTRIBUTE_BOLD='\[\e[1m\]'
ATTRIBUTE_RESET='\[\e[0m\]'
COLOR_DEFAULT='\[\e[39m\]'
COLOR_RED='\[\e[31m\]'
COLOR_GREEN='\[\e[32m\]'
COLOR_YELLOW='\[\e[33m\]'
COLOR_BLUE='\[\e[34m\]'
COLOR_MAGENTA='\[\e[35m\]'
COLOR_CYAN='\[\e[36m\]'

machine_name() {
    if [[ -f $HOME/.name ]]; then
        cat $HOME/.name
    else
        hostname
    fi
}

export CONDA_BASH_PROMPT=""
ps1_update() {
    if [ ! -z "$CONDA_DEFAULT_ENV" ]; then
        export CONDA_BASH_PROMPT=" [${COLOR_GREEN}${CONDA_DEFAULT_ENV}${COLOR_DEFAULT}]"
    else
        export CONDA_BASH_PROMPT=""
    fi
}
PROMPT_COMMAND='ps1_update'

PROMPT_DIRTRIM=3
PS1="${COLOR_BLUE}#${COLOR_DEFAULT} [${COLOR_YELLOW}\w${COLOR_DEFAULT}]\${CONDA_BASH_PROMPT} 🖥 [${COLOR_MAGENTA}$(machine_name)${COLOR_DEFAULT}]\n\$(if [ \$? -ne 0 ]; then echo \"${COLOR_RED}!${COLOR_DEFAULT} \"; fi)\$ "
PS2="\$"
