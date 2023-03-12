export ZSH="${HOME}/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh

export ZSH_THEME_GIT_PROMPT_PREFIX=" on [%{$fg_bold[magenta]%}"
export ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
export ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
export ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
export ZSH_THEME_GIT_PROMPT_CLEAN=""

export ZSH_THEME_RUBY_PROMPT_PREFIX="[%{$fg_bold[red]%}"
export ZSH_THEME_RUBY_PROMPT_SUFFIX="%{$reset_color%}]"

function conda_prompt_info {
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
        case $CONDA_PREFIX in *"$CONDA_DEFAULT_ENV")
            echo " [%{$fg_bold[green]%}${CONDA_DEFAULT_ENV}%{$reset_color%}]"
        esac
    fi
}

function hostname_prompt_info {
    if [[ -n "$HOST" ]]; then
        echo " 🖥  [%{$fg[cyan]%}${HOST}%{$reset_color%}]"
    fi
}

export PROMPT='[%{$fg[yellow]%}%~%{$reset_color%}]$(git_prompt_info)$(virtualenv_prompt_info)$(conda_prompt_info) ⌚ [%{$fg[red]%}%*%{$reset_color%}]$(hostname_prompt_info)
$ '

export RPROMPT='$(ruby_prompt_info)'

export VIRTUAL_ENV_DISABLE_PROMPT=0
export ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" [%{$fg[green]%}"
export ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$reset_color%}]"
export ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
export ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX

export CASE_SENSITIVE=true
export DISABLE_UPDATE_PROMPT=true
export ZSH_DISABLE_COMPFIX=true

plugins=(git)

