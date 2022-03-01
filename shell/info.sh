# conda
# if [[ -f ~/.conda/environments.txt ]]; then
#     echo -e "\033[1;32m----- Conda Environments -----\033[0m"
#     cat ~/.conda/environments.txt | xargs -L1 basename
#     echo -e "\033[1;32m------------------------------\033[0m"
# fi

# tmux
# if [[ -n $TMUX ]]; then
#     echo -e "\033[1;31m----- TMUX session: $(tmux display-message -p '#S') -----\033[0m"
# elif [[ ! -n $TMUX ]] && [[ $(tmux ls 2> /dev/null) ]]; then
#     echo -e "\033[1;31m----- Open tmux sessions -----\033[0m"
#     tmux ls
#     echo -e "\033[1;31m------------------------------\033[0m"
# fi

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

