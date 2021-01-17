#!/bin/sh

# -------------------
# Manage temp scripts
# -------------------

export TMP_SCRIPT_ROOT=/tmp/scripts/

mkdir -p $TMP_SCRIPT_ROOT

_print_available_scripts() {
    find $TMP_SCRIPT_ROOT -type f | cut -c$((${#TMP_SCRIPT_ROOT}+2))-
}

tdelete() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: bdelete <script>"
        return 0
    fi
    filename=$1
    filepath=$TMP_SCRIPT_ROOT/$filename
    if [[ ! -f "${filepath}" ]]; then
        echo "[ ${filename} ] doesn't exist! Available:"
        _print_available_scripts $filename
    else
        rm "${filepath}"
    fi
}

tedit() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: bedit <script>"
        return 0
    fi
    filename=$1
    filepath=$TMP_SCRIPT_ROOT/$filename
    if [[ ! -f "${filepath}" ]]; then
        echo "[ ${filename} ] doesn't exist! Available:"
        _print_available_scripts $filename
    else
        $EDITOR "${filepath}"
    fi
}

tinit() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: bedit <script>"
        return 0
    fi
    filename=$1
    filepath=$TMP_SCRIPT_ROOT/$filename
    mkdir -p $(dirname "$filepath")

    if [[ -f "${filepath}" ]]; then
        echo "[ ${filename} ] already exist! Existing files:"
        _print_available_scripts $filename
    else
        touch ${filepath}
        chmod +x "${filepath}"
        tedit $filename
    fi
}

trun() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: bedit <script>"
        return 0
    fi
    filename=$1
    filepath=$TMP_SCRIPT_ROOT/$filename
    if [[ ! -f "${filepath}" ]]; then
        echo "[ ${filename} ] doesn't exist! Available:"
        _print_available_scripts $filename
    else
        ${filepath} $@
    fi
}

# -----––-------
# Run port scans
# --------------

port-scan() {
  if [[ -z $1 || -z $2 ]]; then
    echo "Usage: $0 <host> <port, ports, or port-range>"
    return
  fi
  
  local host=$1
  local ports=()
  case $2 in
    *-*)
      IFS=- read start end <<< "$2"
      for ((port=start; port <= end; port++)); do
        ports+=($port)
      done
      ;;
    *,*)
      IFS=, read -ra ports <<< "$2"
      ;;
    *)
      ports+=($2)
      ;;
  esac
  
  for port in "${ports[@]}"; do
    perl -e '
        eval {
        $SIG{ALRM} = sub { die };
        alarm shift;
        system(@ARGV);
        };
        if ($@) { exit 1 }
    ' 1 "echo >/dev/tcp/$host/$port" &&
      echo "port $port is open" ||
      echo "port $port is closed"
  done
}


# --------------------------------
# Download files from Google Drive
# --------------------------------

gdrive() {
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

# --------------------------------
# Edit conda environment variables
# --------------------------------

cvars() {
    if [[ ! -n $CONDA_PREFIX ]] || [[ "$CONDA_DEFAULT_ENV" == "base" ]]; then
        echo "Can't edit outside of Conda environment"
        return 0
    fi
    if [[ "$CONDA_DEFAULT_ENV" == "base" ]]; then
        echo "Can't edit base environment variables"
        return 0
    fi

    ACTIVATE=$CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
    DEACTIVATE=$CONDA_PREFIX/etc/conda/deactivate.d/env_vars.sh
    mkdir -p $(dirname $ACTIVATE) $(dirname $DEACTIVATE)

    WRITE_ACTIVATE=true
    WRITE_DEACTIVATE=true
    [[ -f $ACTIVATE ]] && WRITE_ACTIVATE=false
    [[ -f $DEACTIVATE ]] && WRITE_DEACTIVATE=false

    EDIT_ACTIVATE=false
    EDIT_DEACTIVATE=false

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
                EDIT_ACTIVATE=true
                ;;
            deactivate | d)
                EDIT_DEACTIVATE=true
                ;;
            *)
                echo "Invalid option: $1. Expected one of"
                echo "  - rm {r}"
                echo "  - rm-activate {ra}"
                echo "  - rm-deactivate {rd}"
                echo "  - activate {a}"
                echo "  - deactivate {d})"
                return 0
                ;;
        esac
        shift
    done

    if [[ $WRITE_ACTIVATE == true ]]; then
        echo "#! /bin/sh" >> $ACTIVATE
        echo "# $ACTIVATE" >> $ACTIVATE
        echo "" >> $ACTIVATE
        echo "RED='\033[0;31m'" >> $ACTIVATE
        echo "GREEN='\033[0;32m'" >> $ACTIVATE
        echo "ORANGE='\033[0;33m'" >> $ACTIVATE
        echo "BLUE='\033[0;34m'" >> $ACTIVATE
        echo "PURPLE='\033[0;35m'" >> $ACTIVATE
        echo "CYAN='\033[0;35m'" >> $ACTIVATE
        echo "NC='\033[0m'" >> $ACTIVATE
        echo "" >> $ACTIVATE
    fi
    if [[ $WRITE_DEACTIVATE == true ]]; then
        echo "#!/bin/sh" >> $DEACTIVATE
        echo "# $ACTIVATE" >> $DEACTIVATE
        echo "" >> $DEACTIVATE
        echo "RED='\033[0;31m'" >> $DEACTIVATE
        echo "GREEN='\033[0;32m'" >> $DEACTIVATE
        echo "ORANGE='\033[0;33m'" >> $DEACTIVATE
        echo "BLUE='\033[0;34m'" >> $DEACTIVATE
        echo "PURPLE='\033[0;35m'" >> $DEACTIVATE
        echo "CYAN='\033[0;35m'" >> $DEACTIVATE
        echo "NC='\033[0m'" >> $DEACTIVATE
        echo "" >> $DEACTIVATE
    fi

    if [[ "$EDITOR" == "vim" ]]; then
        [[ $EDIT_ACTIVATE == true ]] && vim "+normal G$" +startinsert $ACTIVATE
        [[ $EDIT_DEACTIVATE == true ]] && vim "+normal G$" +startinsert $DEACTIVATE
    else
        [[ $EDIT_ACTIVATE == true ]] && $EDITOR $ACTIVATE
        [[ $EDIT_DEACTIVATE == true ]] && $EDITOR $DEACTIVATE
    fi

    echo "Done editing environment variables for $CONDA_PREFIX"
}
