# Setup fzf
# ---------
if [[ ! "$PATH" == *"$HOME/GIT/github.com/fzf/bin"* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/GIT/github.com/fzf/bin"
fi

source <(fzf --zsh)
