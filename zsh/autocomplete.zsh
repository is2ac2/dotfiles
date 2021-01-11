#/bin/zsh

# conda
_conda_complete() {
    opts=$(cat ~/.conda/environments.txt | xargs -L1 basename | tr '\n' ' ')
    compadd ${=opts}
}
cenv() {
  conda activate $@
}
if [[ -f ~/.conda/environments.txt ]]; then
    compdef _conda_complete cenv
fi

