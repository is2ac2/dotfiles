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
no_color() {
    tput sgr 0
}

# -----------
# OS-Specific
# -----------

case $OSTYPE in
    "darwin"*)
        alias ls='ls -G'

        export SLURM_LOG_DIR=${HOME}/Experiments/.Slurm
        export RUN_DIR=${HOME}/Experiments/Runs
        export LOG_DIR=${HOME}/Experiments/Logs
        export EVAL_DIR=${HOME}/Experiments/Evaluation

        export NLTK_DATA=${HOME}/Software/NLTK/data

        ddate() {
            if [[ $# -lt 1 ]]; then
                echo "Usage: ddate <num-dates-past> (other-args)"
                return 1
            fi
            local delta=$1
            shift
            date -v-${delta}d $@
            return 0
        }
        ;;
    "linux-gnu"*)
        alias ls='ls --color=always'

        export SLURM_LOG_DIR=${HOME}/slurm_logs
        export RUN_DIR=${HOME}/runs
        export LOG_DIR=${HOME}/logs
        export EVAL_DIR=${HOME}/eval

        export NLTK_DATA=${HOME}/software/nltk/data

        ddate() {
            if [[ $# -lt 1 ]]; then
                echo "Usage: ddate <num-dates-past> (other-args)"
                return 1
            fi
            local delta=$1
            shift
            date --date "${delta} days ago" $@
            return 0
        }
        ;;
    *)
        echo "OS type not supported: '$OSTYPE'"
        return
        ;;
esac

mkdir -p $NLTK_DATA

# Some extra bit that seems to be necessary for VSCode.
if [ -d /etc/profile.d ]; then
    for i in /etc/profile.d/*.sh; do
        if [ -r $i ]; then
            . $i
        fi
    done
    unset i
fi

# grep
alias grep='grep --color=always'

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

# sortable time format
export SLURM_TIME_FORMAT='%D (%a) %T'

port-ps() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: port-ps <port-num>"
        return 1
    else
        lsof -nP "-i4TCP:$1"
        return 0
    fi
}

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

    $(blue)shist$(no_color) --starttime=\$(sdate '$(green)7 days ago$(no_color)') --endtime=\$(sdate '$(red)1 hour ago$(no_color)')
    $(blue)shist$(no_color) --starttime=\$(sdate '$(green)24 hours ago$(no_color)') --endtime=\$(sdate '$(red)1 hour ago$(no_color)')
    $(blue)shist$(no_color) --starttime=\$(sdate '$(green)1 hour ago$(no_color)') --endtime=\$(sdate '$(red)now$(no_color)')
"
}

shist() {
    sacct --format='Start%25,End%25,JobID,JobName%30,Partition,State%20' --user $USER $@ | awk 'NR<3{print $0;next}{print$0| "sort -r"}'| less
}

# speed test
speed-test() {
    echo "Runs speed test against remote server

    $(green)speed-test$(no_color) local <machine-name>  $(blue)# Run on the local machine$(no_color)
    $(green)speed-test$(no_color) remote                $(blue)# Run on the remote machine$(no_color)
"

    if [[ $# -eq 0 ]]; then
        echo "Mode required (must be one of [remote|local])"
        return 1
    fi

    local mode=$1
    shift

    case $mode in
        local)
            if [[ $# -lt 1 ]]; then
                echo "Must pass host name"
                return 1
            else
                machine_name=$1
                shift
                iperf -c $machine_name $@
            fi
            ;;
        remote)
            iperf -s $@
            ;;
        *)
            echo "Invalid mode: ${mode} (must be one of [remote|local])"
            return 1
            ;;
    esac

    return 0
}

# less
export LESS="-R"
alias lesc='LESSOPEN="|pygmentize -O style=emacs -g %s" less'

# top
if command -v htop &> /dev/null; then
    alias top='htop'
fi

# python
export PYTHONSTARTUP=$HOME/.python/startup.py
export PYTHONHASHSEED=1337  # For making experiments repeatable

# jupyter
alias jpn='USE_JUPYTER_CONF=1 jupyter notebook'
export JUPYTER_NOTEBOOK_PORT=${JUPYTER_NOTEBOOK_PORT:-44638}

# cuda
export TORCH_CUDA_ARCH_LIST="6.0;7.0"

# fixing vimrc colors inside tmux
export TERM=screen-256color

# tensorboard
alias tbd='tensorboard serve --logdir . --port 6006'

# pwd without symlinks
alias pwd='pwd -P'

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

# kill vscode
kill-vscode() {
    local nprocs=$(pgrep -u $USER -f vscode | wc -l | awk '{ print $1 }')
    echo "($1) Killing ${nprocs} processes"
    case $1 in
        dry)
            pgrep -u $USER -f vscode | xargs ps p
            ;;
        run)
            pkill -15 -u $USER -f vscode
            ;;
        * )
            echo "Unexpected or missing argument: $1"
            echo "Usage: kill-vscode <run|dry>"
            return 1
            ;;
    esac
    return 0
}

# clean vscode (useful for when some extensions freeze up)
clean-vscode() {
    local vscode_dirs=(
        ${HOME}/.vscode/
        ${HOME}/.vscode-insiders/
        ${HOME}/.vscode-server/
        ${HOME}/.vscode-server-insiders/
        ${HOME}/Library/Application\ Support/Code/
        ${HOME}/Library/Application\ Support/Code\ -\ Insiders/
    )
    for vscode_dir in ${vscode_dirs[@]}; do
        if [ -d $vscode_dir ]; then
            echo "($1) Removing $vscode_dir"
            case $1 in
                dry)
                    echo "SKIPPING ACTION"
                    ;;
                run)
                    rm -rf $vscode_dir
                    ;;
                *)
                    echo "Unexpected or missing argument: $1"
                    echo "Usage: clean-vscode <run|dry>"
                    return 1
                    ;;
            esac
        fi
    done
    return 0
}

vsc() {
    if [ $# -lt 1 ]; then
        echo "Usage: vsc <clean|kill>"
        return 1
    fi

    local cmd=$1
    shift

    case $cmd in
        clean)
            clean-vscode $@
            ;;
        kill)
            kill-vscode $@
            ;;
        *)
            echo "Usage: vsc <clean|kill>"
            return 1
            ;;
    esac
    return 0
}

# pgrep with tree (only in bash)
ppgrep() {
    pgrep "$@" | xargs --no-run-if-empty ps fp;
    return 0
}

