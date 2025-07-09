alias dd='dd status=progress bs=100M conv=fsync'
alias df='df -x squashfs -x tmpfs -x devtmpfs'
alias disks="sudo fdisk -l 2>/dev/null | grep GiB | sed 's|^.*/d|/d|g; s|:||g; s|GiB.*$|GiB|g; s| \+|\t|g'"
alias hosts='cat /etc/hosts'
alias his='history | sed -r "s|^[[:blank:]]*[[:digit:]]*[[:blank:]]+||"'
alias l='ls -CF' 
alias la='ls -lha'
alias ll='ls -lh'
alias shcon='source /usr/local/bin/sshconnect.sh'
