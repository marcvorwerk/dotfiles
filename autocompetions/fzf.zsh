# Setup fzf
# ---------
if [[ ! "$PATH" == *"$HOME/GIT/GITHUB/fzf/bin"* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/GIT/GITHUB/MY/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/GIT/GITHUB/MY/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/GIT/GITHUB/MY/fzf/shell/key-bindings.zsh"
