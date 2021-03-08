# C++ flags for programming competitions.
export CXXFLAGS="-Wall -Wextra -O2 -pedantic -std=c++11"

# -------------
# Color aliases
# -------------

red() {
    tput setaf 1
}
green() {
    tput setaf 2
}
yellow() {
    tput setaf 3
}
blue() {
    tput setaf 4
}
magenta() {
    tput setaf 5
}
cyan() {
    tput setaf 6
}
white() {
    tput setaf 7
}
no-color() {
    tput sgr 0
}

# grep
alias grep='grep --color'

# ls
alias ll='ls -lah'
alias la='ls -A'

# protect against overwriting
alias cp='cp -i'
alias mv='mv -i'

# clear
alias cl='clear'
alias reload='exec $SHELL'

# nvidia
alias smi='watch -n1 nvidia-smi'

# time
alias today='date +"%Y-%m-%d'
alias now='date +"%T"'

# slurm
alias squeueme='squeue -u $USER'
alias sshareme='sshare -u $USER'

export SLURM_TIME_FORMAT='%a %D, %T'

sdate() {
    if [[ $# -ne 1  ]]; then
        echo "Usage: sdate <time-string>"
        return 1
    else
        echo $(date +"%Y-%m-%d-%T" -d "$1")
        return 0
    fi
}

shelp() {
    echo "Example slurm commands:

    $(blue)shist$(no-color) --starttime=\$(sdate '$(green)24 hours ago$(no-color)') --endtime=\$(sdate '$(red)1 hour ago$(no-color)')
    $(blue)shist$(no-color) --starttime=\$(sdate '$(green)1 hour ago$(no-color)') --endtime=\$(sdate '$(red)now$(no-color)')
"
}

shist() {
    sacct --format='JobID,JobName%30,Partition,State,Start%25,End%25' --user $USER $@ | less
}

# python
export PYTHONSTARTUP=$HOME/.python/startup.py
export PYTHONHASHSEED=1337  # For making experiments repeatable

# jupyter
alias jpn='USE_JUPYTER_CONF=1 jupyter notebook'

# cuda
export TORCH_CUDA_ARCH_LIST="6.0;7.0"

# fixing vimrc colors inside tmux
export TERM=screen-256color

# tensorboard
alias tbd='tensorboard serve --logdir . --port 6006'

# tmux
tmuxn() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: tmuxn <new-session-name>"
        return 1
    fi

    tmux new-session -d -s $1
    tmux -CC attach -t $1
    return 0
}

# filter top for process regex
topc() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: topc <regex>"
        return 1
    fi

    top -c -p $(pgrep -d',' -f $1)
    return 0
}

# update dotfiles
dfu() {
    if [[ $# -ne 0 ]]; then
        echo "Updates dotfiles. Usage: dfu"
        return 1
    fi

    cd ~/.dotfiles
    git pull --ff-only
    ./install -q
    cd -
    echo "Updated dotfiles; run 'reload' to refresh environment"
    return 0
}

# profile directory
prof() {
    if [[ $# -ne 0 ]]; then
        DEPTH=$1
        shift
    else
        DEPTH=4
    fi

    du -h -d $DEPTH | sort -h
    return 0
}

# make directory and change to that directory
mkcd() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: mkcd <dir-name>"
        return 1
    fi

    mkdir $1
    cd $1
    return 0
}
