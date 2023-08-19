#!/usr/bin/env bash

version="4.4.0"
install_dir="/usr/local/bin"

install_and_upgrade() {
	wget -q --directory-prefix=/tmp "https://github.com/cheat/cheat/releases/download/$1/cheat-linux-amd64.gz"
	cd /tmp
	gunzip -f /tmp/cheat-linux-amd64.gz
	sudo cp cheat-linux-amd64 /usr/local/bin/cheat
        sudo chmod +x /usr/local/bin/cheat
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --version)
        version="$2"
        shift
        shift
        ;;
        *)
        echo "Unrecognized option: $1"
        exit 1
        ;;
    esac
done

if command -v cheat >/dev/null 2>&1; then
    installed_version=$(cheat --version)
    echo "cheat already installed, version: $installed_version"
    if [[ $installed_version != $version ]]; then
        echo "Update cheat to version $version"
	install_and_upgrade $version
        echo "cheat successfully updated to version $version"
    fi
else
    echo "no cheat installation found. Install ..."
    install_and_upgrade $version
    echo "cheat successfully installed, version: $version"
fi


repository_url="git@github.com:cheat/cheatsheets.git"
repository_dir="$HOME/.config/cheat/cheatsheets/community"

if [ -d "$repository_dir" ]; then
    echo "Repo exists. Pull for updates ..."
    cd "$repository_dir"
    git pull 2>&1 >/dev/null && echo "Repo successfully updated." || exit 2
else
    echo "Repository does not exists. Clone ..."
    git clone "$repository_url" "$repository_dir" 2>&1 >/dev/null && echo "Repository successfully cloned." || exit 3
fi

exit 0
