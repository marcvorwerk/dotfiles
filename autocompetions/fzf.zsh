# Setup fzf
# ---------
if [[ ! "$PATH" == *"$HOME/GIT/GITHUB/MY/fzf/bin"* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/GIT/GITHUB/MY/fzf/bin"
fi

source <(fzf --zsh)
