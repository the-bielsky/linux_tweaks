#!/bin/bash
alias dd='dd status=progress bs=100M conv=fsync'
alias df='df -x squashfs -x tmpfs -x devtmpfs'
alias disks="sudo fdisk -l 2>/dev/null | grep GiB | sed 's|^.*/d|/d|g; s|:||g; s|GiB.*$|GiB|g; s| \+|\t|g'"
alias hosts='cat /etc/hosts'
alias his='history | sed -r "s|^[[:blank:]]*[[:digit:]]*[[:blank:]]+||"'
alias l='ls -CF' 
alias la='ls -lha'
alias ll='ls -lh'
alias shcon='source /usr/local/bin/sshconnect.sh'

alias apti='sudo -E apt -y install'
alias aptu='sudo apt update && echo "------------" \
    && apt list --upgradable && echo "------------" \
    && read -p "Press any key to continue or crtl+c to break" \
    && sudo apt upgrade'
alias datestamp='date +%Y%m%d-%H%M'
alias please='sudo'
alias stamp='if [ -n "${PGR_DATESTAMP}" ]; then unset PGR_DATESTAMP; else export PGR_DATESTAMP=1; fi'
alias shcon='source /usr/local/bin/sshconnect.sh'

function _git_pullpush_(){
    local operation=$1
    local BRANCH=$(git branch --show-current); 
    echo GIT: $operation origin $BRANCH; 
    if $(git_status_numeric); then
        sleep 1; 
        trap "echo operation failed; return 1" ERR
        git $operation origin ${BRANCH}
        return 0
    else
        echo Branch $BRANCH is not commited\; operation aborted
        return 1
    fi
}

alias gish='_git_pullpush_ push'
alias gill='_git_pullpush_ pull'

alias vin='code-insiders'
