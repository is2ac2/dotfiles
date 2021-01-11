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
