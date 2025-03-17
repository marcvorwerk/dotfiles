################
### COLORIZE ###
################

# Colorize cat
alias cat=batcat
# Colorize less
alias less=cless


###########
### APT ###
###########

alias allinst="apt list --installed"
alias allpkgs="dpkg --get-selections | grep -v deinstall"


##############
### SAFETY ###
##############

# Confirmation
alias cp='cp -v -i'
alias mv='mv -v -i'
alias ln='ln -v -i'
alias rm='rm -v -i --preserve-root'

# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'


############
### MISC ###
############

alias mkdir="mkdir -v "
alias ll="ls --hyperlink=auto --color=auto -lahv"
alias eza="eza -la --hyperlink"
alias eza-tree="eza --tree --color=always --icons=always --git-ignore --no-quotes --hyperlink'"
alias nn="nnn -e"
alias bc="bc -l"
alias tree='tree -a -I .git'
alias cd-git-root="cd \$(git rev-parse --show-toplevel)"
alias history="history -E"

alias path='echo -e ${PATH//:/\\n}'
alias fpath='echo -e ${FPATH//:/\\n}'

# Remove Comments from File after Pipe
alias no_comment="sed -e 's/\x1b\[[0-9;]*m//g' | grep -o '^[^;#]*' | cat"

### Usage: encrypt_remote host.tld
alias encrypt_remote="ssh -o UserKnownHostsFile=/dev/null -o PubkeyAcceptedAlgorithms=+ssh-rsa -l root -p 2222"

# keep aliases when I use sudo
# https://unix.stackexchange.com/questions/139231/keep-aliases-when-i-use-sudo-bash
alias sudo='sudo '


#################
### DEBUGGING ###
#################

# Get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
# Get top process eating cpu
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# Get Zombie processes
alias ps_zombie="ps ax -o pid,ppid,s,cmd | awk '$3 ~ /Z/'"
