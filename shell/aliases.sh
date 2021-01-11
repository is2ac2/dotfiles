# C++ flags for programming competitions.
export CXXFLAGS="-Wall -Wextra -O2 -pedantic -std=c++11"

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

# nvidia
alias smi='watch -n1 nvidia-smi'

# slurm
alias squeueme='squeue -u $USER'
alias sshareme='sshare -u $USER'

# cuda
export TORCH_CUDA_ARCH_LIST="6.0;7.0"

# filter top for process regex
topc() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: topc <regex>"
        exit 1
    fi
    top -c -p $(pgrep -d',' -f $1)
}

# update dotfiles
dfu() {
    cd ~/.dotfiles
    git pull --ff-only
    ./install -q
}

# for downloading files from google drive
function gdrive {
    if [[ $# -ne 2 ]]; then
        echo "Usage: gdrive <fid> <fpath>"
        return 1
    fi
    FILEID="$1"
    FILENAME="$2"
    O=$(wget \
        --quiet \
        --save-cookies /tmp/cookies.txt \
        --keep-session-cookies \
        --no-check-certificate \
        "https://docs.google.com/uc?export=download&id=${FILEID}" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
    wget \
        --load-cookies /tmp/cookies.txt \
        "https://docs.google.com/uc?export=download&confirm=${O}&id=${FILEID}" -O $FILENAME
    rm -rf /tmp/cookies.txt
    return 0
}
