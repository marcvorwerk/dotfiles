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
        mount | column -t | egrep -v "/snap/"
    else
        command mount "$@"
    fi
}
alias mount="better_mount"

function preview {
	file="$1"
	ext=${file##*.}
	case $ext in
	"json")
		jless "$file"
		;;
	"yml" | "yaml")  # yq ?
		jless "$file"
		;;
	"pdf" | "html")
		xdg-open "$file"
		;;
	"gif" | "png" | "jpg" | "jpeg" | "webp" | "tiff")
		image_viewer=$([[ "$TERM_PROGRAM" == "WezTerm" ]] && echo "wezterm imgcat" || echo "xdg-open")
		$image_viewer "$file"
		;;
	*)
		bat "$file"
		;;
	esac
}


###########
### GIT ###
###########

git_fzf_diff() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}


###########
#### S3 ###
###########

s3env(){
    local S3_ENV=$(find "$HOME/.config/s3cmd" -maxdepth 1 -type f -not -name '.*' -printf "%f\n" | fzf --prompt="Choose a ENV: ")
    alias s3cmd="s3cmd --config=$HOME/.config/s3cmd/$S3_ENV"

}

#################
### OPENSTACK ###
#################

osenv() {
    local osenvfile="$HOME/.config/openstack/clouds.yaml"
    if [ ! -f $osenvfile ]; then
    echo "File not found!"
    return 1
    fi
    local OS_ENV=$(yq eval -r '.clouds | keys | .[]' $osenvfile | fzf --prompt="Choose a Cloud: ")
    if [[ -n "$OS_ENV" ]]; then
        export OS_CLOUD="$OS_ENV"
    else
        echo "No Cloud selected"
    fi
}

# Create OpenStack Test Instance
openstack_create_test_instance () {
    local INSTANCE_NAME IMAGE_ID FLAVOR_ID KEY_ID NETWORK_ID AZ_NAME
    vared -p "Enter Instance Name (Default [Enter]: autotestserver$(date '+%d.%m.%Y_%H.%M')): " -c INSTANCE_NAME
    : ${INSTANCE_NAME:=autotestserver$(date '+%d.%m.%Y_%H.%M')}

    local MODIFY="grep -v -e '^+-' -e '^| ID' | sed 's/^| //' | sed 's/ \+|$//'"

    IMAGE_ID=$(openstack image list --status active -c ID -c Name | eval $MODIFY | \
        fzf --prompt "Image: " --tac --no-sort | awk '{print $1}')

    FLAVOR_ID=$(openstack flavor list -c ID -c Name | eval $MODIFY | \
        fzf --prompt "Flavor: " --preview-window=up --tac --no-sort | awk '{print $1}')

    KEY_ID=$(openstack keypair list | eval $MODIFY | grep -v "Fingerprint" | \
        fzf --prompt "Key: " --tac --no-sort | awk '{print $1}')

    NETWORK_ID=$(openstack network list --enable --internal -c ID -c Name | eval $MODIFY | \
        fzf --prompt "Network: " --tac --no-sort | awk '{print $1}')

    AZ_NAME=$(openstack availability zone list --compute | eval $MODIFY | \
        sed 's/ \+| available$//' | grep -v "Zone Name | Zone Status" | \
        fzf --prompt "AZ: " --tac --no-sort | awk '{print $1}')

    openstack server create \
        --image "$IMAGE_ID" \
        --flavor "$FLAVOR_ID" \
        --key-name "$KEY_ID" \
        --network "$NETWORK_ID" \
        --availability-zone "$AZ_NAME" \
        "$INSTANCE_NAME"
}
