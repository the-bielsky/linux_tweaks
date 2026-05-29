#!/bin/bash
# This file is sourced by /etc/profile, and is used to set up aliases for the user.

alias dd='dd status=progress bs=100M conv=fsync'
alias df='df -x squashfs -x tmpfs -x devtmpfs'

alias l='ls -CF' 
alias la='ls -lha'
alias ll='ls -lh'

alias disks="sudo fdisk -l 2>/dev/null | grep GiB | sed 's|^.*/d|/d|g; s|:||g; s|GiB.*$|GiB|g; s| \+|\t|g'"
alias hosts='cat /etc/hosts'

# mount sshfs using in ~/media/
alias shcon='source /usr/local/bin/sshconnect.sh'

alias apti='sudo -E apt -y install'
alias aptu='sudo apt update && echo "------------" \
    && apt list --upgradable && echo "------------" \
    && read -p "Press any key to continue or crtl+c to break" \
    && sudo apt upgrade'
alias datestamp='date +%Y%m%d-%H%M'
alias stamp='if [ -n "${PGR_DATESTAMP}" ]; then unset PGR_DATESTAMP; else export PGR_DATESTAMP=1; fi'
alias his='history | sed -r "s|^[[:blank:]]*[[:digit:]]*[[:blank:]]+||"'
alias vin='code-insiders'

# if you can't open file in vscode from terminal, run this command to regenerate the vscode ipc socket path
alias code_regen='export VSCODE_IPC_HOOK_CLI="$(ls -t /run/user/$UID/vscode-ipc-*.sock 2>/dev/null | head -n1)"'

# easter eggs
alias please='sudo'
