#!/bin/sh

# Show an error if this fails for some reason.
# err_report() {
#     echo "Error on line $1"
# }
# trap 'err_report $LINENO' ERR

# C++ flags for programming competitions.
# export CXXFLAGS="-Wall -Wextra -O2 -pedantic -std=c++11"

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
        export LOG_DIR=${HOME}/Experiments/Logs
        export EVAL_DIR=${HOME}/Experiments/Evaluation
        export DATA_DIR=${HOME}/Experiments/Data
        export DATA_CACHE_DIR=${DATA_DIR}/.Cache
        export MODEL_DIR=${HOME}/Experiments/Models
        export STAGE_DIR=${HOME}/Experiments/Stage
        export RUN_DIR=${LOG_DIR}/today
        export EVAL_RUN_DIR=${EVAL_DIR}/today

        alias date='gdate'
        ;;
    "linux-gnu"*)
        alias ls='ls --color=always'

        export SLURM_LOG_DIR=${HOME}/Experiments/Slurm
        export LOG_DIR=${HOME}/Experiments/Logs
        export EVAL_DIR=${HOME}/Experiments/Evaluation
        export DATA_DIR=${HOME}/Experiments/Data
        export DATA_CACHE_DIR=${DATA_DIR}/.Cache
        export MODEL_DIR=${HOME}/Experiments/Models
        export STAGE_DIR=${HOME}/Experiments/Stage
        export RUN_DIR=${LOG_DIR}/today
        export EVAL_RUN_DIR=${EVAL_DIR}/today
        ;;
    *)
        echo "OS type not supported: '$OSTYPE'"
        return
        ;;
esac

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
alias cgrep='grep --color=always'

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
alias smi='watch -n0.1 nvidia-smi'

# time
alias today='date +"%Y-%m-%d'
alias now='date +"%T"'

# slurm
alias qm='squeue -u $USER'

# paths
alias rp='realpath'

# sortable time format
export SLURM_TIME_FORMAT='%D (%a) %T'

# kill stopped jobs
alias kill-stopped='kill -9 `jobs -ps`'

# kill python jobs
alias killall-py='killall -u ${USER} -n python'

# show a warning if startup takes longer than this
export SLOW_STARTUP_WARNING_MS=1000

spartme() {
    if [[ $# -ne 1 ]]; then
        echo "Changes all existing jobs to a partition"
        echo "Usage: spartme <partition>"
    fi
    partition=$1
    jobids=$(squeue -u $USER -h -t PD -o %i)
    numjobs=$(echo $jobids | wc -w)
    echo "Changing $numjobs jobs to $partition partition"
    for i in ${jobids[@]}; do
        scontrol update jobid=$i partition=$partition
    done
}

portps() {
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

slog() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: sl <job-id>"
        return 1
    fi
    local job_id=$1; shift
    echo $(slurm-parse-comment $job_id -p 'Log directory: ')
}

sl() {
    local log_dir=$(slog $@)
    if [[ -n $log_dir ]]; then
        less ${log_dir}/logs/slurm_out.txt
    else
        echo "Failed to get log directory for job ID $1"
        return 1
    fi
}

sle() {
    local log_dir=$(slog $@)
    if [[ -n $log_dir ]]; then
        local last_err_file=$(\ls -1 ${log_dir}/logs/slurm_err.*.txt | tail -n 1)
        less ${last_err_file}
    else
        echo "Failed to get log directory for job ID $1"
        return 1
    fi
}

stbd() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: stbd <job-id> (<job_id>...)"
        return 1
    fi

    local tmp_tbd_dir=$(mktemp -d -t tbd-XXXXXXXX)
    local has_dir=0
    for job_id in "$@"; do
        local log_dir=$(slog $job_id)
        local tbd_root=${log_dir}/logs/tensorboard/
        local last_tbd_dir=$(\ls -1 ${tbd_root} | sort | tail -n 1)
        if [[ -n $last_tbd_dir ]]; then
            local tbd_full_dir=${tbd_root}${last_tbd_dir}
            echo "-> ${tbd_full_dir}"
            ln -s ${tbd_full_dir} ${tmp_tbd_dir}/${job_id}
            has_dir=1
        else
            echo "Failed to get log directory for job ID $job_id"
        fi
    done

    if [[ $has_dir -eq 0 ]]; then
        echo "No log directories found"
        return 1
    fi

    local cmd="tensorboard serve --logdir ${tmp_tbd_dir}"
    if [[ -n $TENSORBOARD_PORT ]]; then
        cmd="${cmd} --port ${TENSORBOARD_PORT}"
    else
        cmd="${cmd} --bind_all"
    fi

    echo "Running '$cmd'"
    eval $cmd

    rm -r $tmp_tbd_dir
}

# speed test
speedtest() {
    echo "Runs speed test against remote server

    $(green)speedtest$(no_color) local <machine-name>  $(blue)# Run on the local machine$(no_color)
    $(green)speedtest$(no_color) remote                $(blue)# Run on the remote machine$(no_color)
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
alias lesg='less ++G'  # Automatically jump to end

# python
export PYTHONHASHSEED=1337  # For making experiments repeatable
export PYTHONSTARTUP="${HOME}/.python/startup.py"

# jupyter
alias jpn='USE_JUPYTER_CONF=1 jupyter notebook'
export JUPYTER_NOTEBOOK_PORT=${JUPYTER_NOTEBOOK_PORT:-44638}

clear-jpn() {
    local dir
    if [[ $# -eq 0 ]]; then
        dir=$(pwd)
    else
        dir=$1
    fi
    dir=$(realpath $dir)
    echo "Clearing all Jupyter notebooks in ${dir}"
    find . -type f -name "*.ipynb" -exec jupyter nbconvert --clear-output {} \;
}

# cuda
export TORCH_CUDA_ARCH_LIST="6.0;6.1;6.2;7.0;7.5;8.0"

# fixing vimrc colors inside tmux
export TERM=screen-256color

# tensorboard
tbd() {
    local cmd
    local extra

    if [[ -n $TENSORBOARD_PORT ]] && [[ $# -ne 2 ]]; then
        extra="--port ${TENSORBOARD_PORT}"
    else
        extra="--bind_all"
    fi

    if [[ $# -eq 0 ]]; then
        cmd="tensorboard serve --reload_interval 30 --logdir . ${extra}"
    elif [[ $# -eq 1 ]]; then
        cmd="tensorboard serve --reload_interval 30 --logdir $1 ${extra}"; shift
    elif [[ $# -eq 2 ]]; then
        cmd="tensorboard serve --reload_interval 30 --logdir $1 --port $2 ${extra}"; shift; shift
    else
        echo "Usage: tbd (<directory>) (<port>)"
    fi
    echo "Running '$cmd'"
    eval $cmd
}

# pwd without symlinks
alias pwd='pwd -P'

# conda
alias cdenv='conda deactivate'

# tmux
tmuxn() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: tmuxn <new-session-name>"
        return 1
    fi

    tmux new-session -d -s $1
    echo "Created session $1"
    return 0
}

tmuxd() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: tmuxd <session-to-close>"
        return 1
    fi

    tmux kill-session -t $1
    echo "Closed session $1"
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

# change to last directory alphabetically (useful for date folders)
cb() {
    local last_dir
    last_dir=$(\ls -1 | tail -1)
    echo "cd ${last_dir}"
    cd ${last_dir}
}

# kill vscode
__kill_vscode() {
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
            echo "Usage: vsc kill <run|dry>"
            return 1
            ;;
    esac
    return 0
}

# clean vscode (useful for when some extensions freeze up)
__clean_vscode() {
    local vscode_dirs
    vscode_dirs[0]=${HOME}/.vscode/
    vscode_dirs[1]=${HOME}/.vscode-insiders/
    vscode_dirs[2]=${HOME}/.vscode-server/
    vscode_dirs[3]=${HOME}/.vscode-server-insiders/
    vscode_dirs[4]=${HOME}/Library/Application\ Support/Code/
    vscode_dirs[5]=${HOME}/Library/Application\ Support/Code\ -\ Insiders/
    vscode_dirs[6]=${HOME}/.config/Code/
    vscode_dirs[7]=${HOME}/.config/Code\ -\ Insiders/
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
                    echo "Usage: vsc clean <run|dry>"
                    return 1
                    ;;
            esac
        fi
    done

    local num_tmp=$(find /tmp/ -maxdepth 1 -user $USER -name "*vscode*" 2> /dev/null | wc -l | awk '{ print $1 }')
    echo "($1) Removing $num_tmp temp files"

    case $1 in
        dry)
            echo "SKIPPING ACTION"
            ;;
        run)
            find /tmp/ -maxdepth 1 -user $USER -name "*vscode*" -exec rm -rf {} \; 2> /dev/null
            ;;
        *)
            echo "Unexpected or missing argument: $1"
            echo "Usage: vsc clean <run|dry>"
            return 1
            ;;
    esac

    return 0
}

__clean_cache_vscode() {
    local vscode_dirs
    vscode_dirs[0]=${HOME}/Library/Application\ Support/Code/
    vscode_dirs[1]=${HOME}/Library/Application\ Support/Code\ -\ Insiders/
    vscode_dirs[2]=${HOME}/.config/Code/
    vscode_dirs[3]=${HOME}/.config/Code\ -\ Insiders/
    for vscode_dir in ${vscode_dirs[@]}; do
        state_db=$vscode_dir/User/globalStorage/state.vscdb

        # Deletes cache of Python interpreters.
        if [ -d $state_db ]; then
            sqlite3 $state_db "DELETE FROM ItemTable WHERE key = 'ms-python.python';"
        fi
    done
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
            __clean_vscode $@
            ;;
        kill)
            __kill_vscode $@
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

# Shows process tree.
alias psme='pstree -p $(whoami)'

# ubuntu: combine apt update && upgrade
aptu() {
    apt update
    apt upgrade
    apt autoremove
}

# NVM
export NVM_DIR="$HOME/.nvm"
load-nvm() {
    unalias nvm 2> /dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

alias nvm='load-nvm && \nvm'
alias npm='load-nvm && \npm'

# Ruby
load-ruby() {
    unalias rbenv 2> /dev/null
    unalias rvm 2> /dev/null
    unalias chruby 2> /dev/null
    unalias ruby 2> /dev/null
    unalias bundle 2> /dev/null
    unalias gem 2> /dev/null

    # Loads Homebrew.
    load-brew

    # Loads rbenv.
    if command -v rbenv &> /dev/null ; then
        eval "$(rbenv init - zsh)"
    fi

    # Loads RVM.
    pathadd PATH ${HOME}/.rvm/bin > /dev/null
    if [ -f $HOME/.rvm/scripts/rvm ]; then
        source $HOME/.rvm/scripts/rvm
    fi

    # Loads chruby.
    local found_chruby=0
    if [ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]; then
        source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
        source /opt/homebrew/opt/chruby/share/chruby/auto.sh
        found_chruby=1
    elif [ -f /usr/local/share/chruby/chruby.sh ]; then
        source /usr/local/share/chruby/chruby.sh
        source /usr/local/share/chruby/auto.sh
        found_chruby=1
    fi

    # Gets the latest version in ~/.rubies
    if [ $found_chruby -eq 1 ]; then
        local latest_ruby=$(\ls -1 ${HOME}/.rubies | tail -1)
        if [ -n "$latest_ruby" ]; then
            chruby $latest_ruby
        else
            echo "No rubies found in ${HOME}/.rubies"
        fi
    fi
}

alias rbenv='load-ruby && \rbenv'
alias rvm='load-ruby && \rvm'
alias chruby='load-ruby && \chruby'
alias ruby='load-ruby && \ruby'
alias bundle='load-ruby && \bundle'
alias gem='load-ruby && \gem'

# Homebrew
export HOMEBREW_PREFIX=/opt/homebrew
load-brew() {
    unalias brew 2> /dev/null

    if [ -d $HOMEBREW_PREFIX ]; then
        pathadd PATH ${HOMEBREW_PREFIX}/bin > /dev/null
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

alias brew='load-brew && \brew'

# Conda
export CONDA_DIR="${HOME}/.miniconda3"
export CONDA_DEFAULT_PYTHON_VERSION=3.10

# History search
alias hgr='history | grep'

# React
export REACT_EDITOR=vscode

# Alert
alias alert='notify-send --urgency=low -i "$([ $? = 0  ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# -------------------
# Manage temp scripts
# -------------------

export TMP_SCRIPT_ROOT=$HOME/.tmp-scripts/

(mkdir -p $TMP_SCRIPT_ROOT $SLURM_LOG_DIR $LOG_DIR $EVAL_DIR $DATA_DIR $DATA_CACHE_DIR $MODEL_DIR $STAGE_DIR &)

_print_available_scripts() {
    find $TMP_SCRIPT_ROOT -type f | cut -c${#TMP_SCRIPT_ROOT}- | sed 's:/*::'
}

tdelete() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: tdelete <script>"
        return 1
    fi
    local filename=$1
    local filepath=$TMP_SCRIPT_ROOT/$filename
    if [[ ! -f "${filepath}" ]]; then
        echo "[ ${filename} ] doesn't exist! Available:"
        _print_available_scripts
    else
        rm "${filepath}"
        find $TMP_SCRIPT_ROOT -type d -empty -delete
    fi
}

tedit() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: tedit <script>"
        return 1
    fi
    local filename=$1
    local filepath=$TMP_SCRIPT_ROOT/$filename
    if [[ ! -f "${filepath}" ]]; then
        echo "[ ${filename} ] doesn't exist! Available:"
        _print_available_scripts
    else
        $EDITOR "${filepath}"
    fi
}

tinit() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: tinit <script>"
        return 1
    fi
    local filename=$1
    local filepath=$TMP_SCRIPT_ROOT/$filename
    mkdir -p $(dirname "$filepath")

    if [[ -f "${filepath}" ]]; then
        echo "[ ${filename} ] already exist! Existing files:"
        _print_available_scripts
    else
        touch ${filepath}
        chmod +x "${filepath}"
        tedit $filename
    fi
}

trun() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: trun <script>"
        return 1
    fi
    local filename=$1
    shift
    local filepath=$TMP_SCRIPT_ROOT/$filename
    if [[ ! -f "${filepath}" ]]; then
        echo "[ ${filename} ] doesn't exist! Available:"
        _print_available_scripts
    else
        ${filepath} $@
    fi
}

# --------------------------------
# Download files from Google Drive
# --------------------------------

gdrive() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: gdrive <google-fid> <output-path>"
        return 1
    fi
    local FILEID="$1"
    local FILENAME="$2"
    O=$(wget \
        --quiet \
        --save-cookies /tmp/gdrive-cookies.txt \
        --keep-session-cookies \
        --no-check-certificate \
        "https://docs.google.com/uc?export=download&id=${FILEID}" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
    wget \
        --load-cookies /tmp/gdrive-cookies.txt \
        "https://docs.google.com/uc?export=download&confirm=${O}&id=${FILEID}" -O $FILENAME
    rm -f /tmp/gdrive-cookies.txt
    return 0
}

# --------------------------------
# Edit conda environment variables
# --------------------------------

cn-vars() {
    if [[ ! -n $CONDA_PREFIX ]] || [[ "$CONDA_DEFAULT_ENV" == "base" ]]; then
        echo "Can't edit outside of Conda environment"
        return 1
    fi

    local CONDA_ENV_NAME=$(basename $CONDA_PREFIX)
    local ACTIVATE=$CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
    local DEACTIVATE=$CONDA_PREFIX/etc/conda/deactivate.d/env_vars.sh
    mkdir -p $(dirname $ACTIVATE) $(dirname $DEACTIVATE)

    local WRITE_ACTIVATE=1
    local WRITE_DEACTIVATE=1
    [[ -f $ACTIVATE ]] && WRITE_ACTIVATE=false
    [[ -f $DEACTIVATE ]] && WRITE_DEACTIVATE=false

    local EDIT_ACTIVATE=0
    local EDIT_DEACTIVATE=0

    while [[ $# -gt 0 ]]; do
        case $1 in
        rm | r)
            rm $ACTIVATE $DEACTIVATE
            ;;
        rm-activate | ra)
            rm $ACTIVATE
            ;;
        rm-deactivate | rd)
            rm $DEACTIVATE
            ;;
        activate | a)
            EDIT_ACTIVATE=1
            ;;
        deactivate | d)
            EDIT_DEACTIVATE=1
            ;;
        *)
            echo "Invalid option: $1. Expected one of"
            echo "  - rm {r}"
            echo "  - rm-activate {ra}"
            echo "  - rm-deactivate {rd}"
            echo "  - activate {a}"
            echo "  - deactivate {d}"
            return 1
            ;;
        esac
        shift
    done

    if [[ $WRITE_ACTIVATE == 1 ]]; then
        echo "#!/bin/sh" >>$ACTIVATE
        echo "# $ACTIVATE" >>$ACTIVATE
        echo "" >>$ACTIVATE
    fi
    if [[ $WRITE_DEACTIVATE == 1 ]]; then
        echo "#!/bin/sh" >>$DEACTIVATE
        echo "# $DEACTIVATE" >>$DEACTIVATE
        echo "" >>$DEACTIVATE
    fi

    [[ $EDIT_ACTIVATE == 1 ]] && $EDITOR $ACTIVATE
    [[ $EDIT_DEACTIVATE == 1 ]] && $EDITOR $DEACTIVATE

    echo "Done editing environment variables for $CONDA_PREFIX; reloading..."
    conda deactivate
    conda activate $CONDA_ENV_NAME
    return 0
}

# ------------------------------
# Create a new Conda environment
# ------------------------------

cn-new() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: cn-new <env-name>"
        return 1
    fi
    local ENV_NAME=$1
    conda create -n $ENV_NAME python=$CONDA_DEFAULT_PYTHON_VERSION
    conda deactivate
    conda activate $ENV_NAME
}

# ---------------
# Tools for Slurm
# ---------------

slurm-allocate() {
    if [ $# -ne 0 ]; then
        echo "Usage: allocate"
        echo "  Allocates an empty cluster in SLURM"
        return 1
    fi

    sbatch \
        --gres=gpu:volta:8 \
        --wrap "sleep 259200" \
        --constraint volta32gb \
        --time 1440 \
        --exclusive \
        --partition dev \
        --mem 480G \
        --output /tmp/slurm-%j.out \
        --error /tmp/slurm-%j.err
    return 0
}

alias allocate=slurm-allocate

# ----------------
# Tools for `make`
# ----------------

brun() {
    if [ $# -lt 1 ]; then
        echo "Usage: brun <fpath> (runtime-args)"
        echo "  Make a file (if not up-to-date), then run it if make succeeds"
        return 1
    fi

    local fpath=$1
    shift

    local fname=$(basename "$fpath")
    local dname=$(dirname "$fpath")
    cd $dname

    local extname=$(find $dname -type f -name "$fname.*" | head -1)
    if [[ -n ${extname} ]]; then
        echo "Assuming you meant '${extname}'"
        fname=$extname
    fi

    local base="${fname%.*}"
    local ext=$(echo "${fname##*.}" | awk '{print tolower($0)}')

    case $ext in
        $base)
            echo "No extension found"
            ;;
        cc|cpp|c)
            make $base && ./$base $@
            ;;
        cu)
            nvcc $base.$ext -o $base && ./$base $@
            ;;
        *)
            echo "Extension not supported: $ext"
            ;;
    esac

    cd -
}

# ---------------------
# Query GPU Utilization
# ---------------------

smiq() {
    local options outf query_str

    options=(
        timestamp
        name
        driver_version
        pstate
        pcie.link.gen.max
        pcie.link.gen.current
        temperature.gpu
        utilization.gpu
        utilization.memory
        memory.total
        memory.free
        memory.used
    )

    outf=/tmp/gpu-usage-$HOSTNAME.csv
    echo "Writing to $outf"

    query_str=$(printf ",%s" "${options[@]}")
    query_str=${query_str:1}

    nvidia-smi \
        --query-gpu=$query_str \
        --format=csv \
        --loop-ms=500 \
        --filename=$outf \

    return 0
}

# --------------------
# Writes storage usage
# --------------------

get-storage() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: get-storage <fpath>"
        return 1
    fi

    fpath=$1
    shift

    # Creates a temporary file for reading errors.
    local tmpfile=$(mktemp /tmp/abc-script.XXXXXX)

    # Removes existing file path.
    rm -f $fpath

    # Logs current date.
    date 2>> $tmpfile >> $fpath
    echo "" >> $fpath

    # Logs information about the entire file system.
    df -h -a 2>> $tmpfile >> $fpath

    # Logs information about the local disk.
    echo "" >> $fpath
    echo "===== LOCAL DISK =====" >> $fpath
    df -h ${HOME} 2>> $tmpfile >> $fpath

    # Logs the top offending directories.
    echo "" >> $fpath
    echo "===== TOP DIRECTORIES =====" >> $fpath
    du -h -d 4 2>> $tmpfile | sort -r -h >> $fpath

    # Appends error messages, if there are any.
    if [[ -s $tmpfile ]]; then
        echo "" >> $fpath
        echo "===== ERRORS =====" >> $fpath
        cat $tmpfile >> $fpath
    fi
    rm $tmpfile

    chmod 444 $fpath
}

# ------------------
# Less on file group
# ------------------

gless() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: gless <file-group>"
        return 1
    fi
    sed -s '$a\\n[ ---------- ]\n' $@ | less
}

# ---------------------------------
# Manage path environment variables
# ---------------------------------

pathadd() {
    if [[ $# -ne 2 ]] && [[ $# -ne 3 ]]; then
        echo "Usage: pathadd <var> <new-path>"
        return 1
    fi
    local var=$1
    local new_path=$2
    local prev_val="$(env-val $var):"
    if [[ -d "${new_path}" ]]; then
        if [[ ":${prev_val}:" != *":${new_path}:"* ]]; then
            if [[ $# -eq 3 ]] && [[ $3 == "append" ]]; then
                export ${var}=${prev_val}:${new_path}
            else
                export ${var}=${new_path}:${prev_val}
            fi
        fi
    else
        echo "Missing: ${new_path}"
    fi
}

pathclean() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: pathclean <var>"
        return 1
    fi
    local var=$1
    local prev_val="$(env-val $var):"
    local new_val
    while read -d ':' dir; do
        if [[ ":${new_val}:" != *":${dir}:"* ]] && [[ -d ${dir} ]]; then
            new_val="${new_val:+"$new_val:"}${dir}"
        fi
    done <<< ${prev_val}
    export ${var}="${new_val}"
}
