################
### COLORIZE ###
################

# echo RED
echor() {
    echo -e "\e[31m$@\e[0m"
}

# echo BLUE
echob() { 
    echo -e "\e[34m$@\e[0m"
}

# echo GREEN
echog() { 
    echo -e "\e[32m$@\e[0m"
}

# echo YELLOW
echoy() { 
    echo -e "\e[33m$@\e[0m"
}


#############
### NOTES ###
#############

quicknote_func() {
    if [[ $# == 0 ]]; then
	cat ~/.quicknote
    elif [[ "$1" == "edit" ]]; then
        $EDITOR ~/.quicknote
	return 0
    elif [[ "$1" == "--help" ]]; then
        echo "Usage: quicknote | show Notes"
        echo "Usage: quicknote <comment> | Creates new Note"
        echo "Usage: quicknote <edit> | Edit Notes"
        return 1
    else
	echo "$(date +'%F %R'): $*" >> ~/.quicknote
    fi
}
alias quicknote=' noglob quicknote_func'


###########
### SSH ###
###########

sshdiff() {
    #vimdiff <(ssh "$1" ${@:3}) <(ssh "$2" ${@:3})
    vimdiff <(ssh -t -f -q -o BatchMode=yes "$1" "cat ${@:3}") <(ssh -t -f -q -o BatchMode=yes "$2" "cat ${@:3}")
}



###########
### WEB ###
###########

google() {
    if [ $# -eq 0 ]; then
        echo "Usage: google <search terms>"
        return 1
    fi
    local search
    local query
    for word in "$@"; do
        search+=" $word"
        query+="$word+"
    done
    search=${search# }  # Remove leading space
    query=${query%+}     # Remove trailing plus sign
    echo "Searching for: '$search'"
    xdg-open "https://www.google.de/search?q=$query"
}


############
### MISC ###
############

math() {
bc <<< "$@"
}

pipe2vim() {
	() { vim $1 </dev/tty >/dev/tty && cat $1 } =(cat)
}

# wat - a better and recursive which/whence
function wat() {
    ( # constrain unalias
    for cmd; do
        if (( $+aliases[$cmd] )); then                                                                                                                 
            printf '%s: aliased to %s\n' $cmd $aliases[$cmd]
            local -a words=(${${(z)aliases[$cmd]}:#(*=*|rlwrap|noglob|command)})
            unalias $cmd
            if [[ $words[1] == '\'* ]]; then
                words[1]=${words[1]#'\'}
                unalias $words[1] 2>/dev/null
            fi
            wat $words[1]
        elif (( $+functions[$cmd] )); then
            whence -v -- $cmd
            whence -f -- $cmd
        elif (( $+commands[$cmd] )); then
            wat $commands[$cmd]
        elif [[ -h $cmd ]]; then
            file $cmd
            wat $cmd:A
        elif [[ -x $cmd ]]; then
            file -- $cmd
        else
            which -- $cmd
        fi
    done
    )
}
compdef wat=which

function better_mount() {
    if [ $# -eq 0 ]; then
        mount | column -t
    else
        command mount "$@"
    fi
}
alias mount="better_mount"

###########
### GIT ###
###########

git_fzf_diff() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}


#################
### OPENSTACK ###
#################

echo -e "#!/bin/bash\nexport PATH=$PATH" > /tmp/restore_path
osenv() {
    osenvfiles="$HOME/.config/openstack/ENV"
    export OS_ENV=$(find $osenvfiles \! -executable -type f -printf "%f\n" | sed 's/ /\n/g'| sort | fzf)
    source $osenvfiles/$OS_ENV
}
