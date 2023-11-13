export GPG_TTY=$TTY
export TERMINAL=tilix
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export LESS='-iR'
export SYSTEMD_PAGER='cat'
export CHEAT_USE_FZF=true
export PAGER='less -FRX'

export TIMEFMT=$'\n  Job Name: %J \n  Time: %E \n  User: %U \n  System: %S \n  CPU: %P \n  Memory: %MM \n  Total: %*Es'

unsetopt sharehistory
setopt EXTENDED_HISTORY
export HISTTIMEFORMAT="[%F %T] "
export HISTCONTROL=ignoredups:ignorespac
export HISTFILESIZE=1000000
export HISTSIZE=1000000

export ANSIBLE_VAULT_PASSWORD_FILE=secret
