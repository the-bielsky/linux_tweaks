#!/bin/bash
# check if the script is running in ubuntu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ]; then
        echo "This script is only for Ubuntu"
        exit 1
    fi
else
    echo "This script is only for Ubuntu"
    exit 1
fi
# check gh is installed
if [ -x "$(command -v gh)" ]; then
    echo "gh is already installed"
    exit 1
fi

# check if the script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

logdir=/var/log/local_installation
mkdir -p "$logdir"
LOGFILE="${logdir}/instance_install.log"
function log() {
    echo "$(date) - $@" 
    echo "$(date) - $@" >> $LOGFILE
}

trap "log 'Script interrupted by user $0'; exit 1" TERM INT
trap "log 'Script ERROR' $0; exit 1" ERR

mkdir -p -m 755 /etc/apt/keyrings
out=$(mktemp) 
wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg 
cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null 
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg 
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null 
apt update
apt info gh
apt install gh -y
log "GitHub CLI installed"
trap - TERM INT ERR
log "Script $0 completed"
exit 0