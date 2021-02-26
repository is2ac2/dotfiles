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
