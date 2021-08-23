#!/bin/bash

# -------------------
# Manage temp scripts
# -------------------

export TMP_SCRIPT_ROOT=$HOME/.tmp-scripts/

mkdir -p $TMP_SCRIPT_ROOT

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

cvars() {
    if [[ ! -n $CONDA_PREFIX ]] || [[ "$CONDA_DEFAULT_ENV" == "base" ]]; then
        echo "Can't edit outside of Conda environment"
        return 1
    fi

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
        echo "#! /bin/sh" >>$ACTIVATE
        echo "# $ACTIVATE" >>$ACTIVATE
        echo "" >>$ACTIVATE
    fi
    if [[ $WRITE_DEACTIVATE == 1 ]]; then
        echo "#!/bin/sh" >>$DEACTIVATE
        echo "# $DEACTIVATE" >>$DEACTIVATE
        echo "" >>$DEACTIVATE
    fi

    if [[ "$EDITOR" == "vim" ]]; then
        [[ $EDIT_ACTIVATE == 1 ]] && vim "+normal G$" +startinsert $ACTIVATE
        [[ $EDIT_DEACTIVATE == 1 ]] && vim "+normal G$" +startinsert $DEACTIVATE
    else
        [[ $EDIT_ACTIVATE == 1 ]] && $EDITOR $ACTIVATE
        [[ $EDIT_DEACTIVATE == 1 ]] && $EDITOR $DEACTIVATE
    fi

    echo "Done editing environment variables for $CONDA_PREFIX"
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

    local cyan=`tput setaf 6`
    local green=`tput setaf 2`
    local reset=`tput sgr0`

    local extname=$(find $dname -type f -name "$fname.*" | head -1)
    if [[ -n ${extname} ]]; then
        echo "$(cyan)Assuming you meant $(green)${extname}$(nc)"
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

# -----------------
# Tools for hosting
# -----------------

serve() {
    # Helper alias for http-server.
    # Install server with `nmp install --global http-server`

    local help_str="Usage: serve <local|shared> (<port>)"

    # Parses command line arguments.
    mode='local'
    port=8082
    [ $# -gt 0 ] && mode=$1 ; shift
    [ $# -gt 0 ] && port=$1 ; shift
    if [ $# -ne 0 ]; then
        echo "Found $# unused arguments: $@"
        echo $help_str
        return 1
    fi

    case $mode in
        "local")
            http-server \
                -a localhost \
                -p $port
            ;;
        "shared")
            local username="dart"  # local username=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')
            local password=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')
            echo "Username: $username"
            echo "Password: $password"
            http-server \
                -p $port \
                --username $username \
                --password $password
            ;;
        *)
            echo "Invalid argument: $1"
            echo $help_str
            ;;
    esac
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

    # Logs storage information.
    rm -f $fpath
    df -h 2> $tmpfile > $fpath
    echo "" >> $fpath
    echo "===== TOP DIRECTORIES =====" >> $fpath
    du -h -d 4 2> $tmpfile | sort -r -h >> $fpath

    # Appends error messages, if there are any.
    if [[ -s $tmpfile ]]; then
        echo "" >> $fpath
        echo "===== ERRORS =====" >> $fpath
        cat $tmpfile >> $fpath
    fi
    rm $tmpfile

    chmod 444 $fpath
}

