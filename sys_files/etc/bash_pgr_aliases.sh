alias apti='sudo -E apt -y install'
alias aptu='sudo apt update && echo "------------" && apt list --upgradable && echo "------------" && sudo apt -y upgrade'
# alias beeper='isok=$? /usr/local/sbin/beeper'
# alias cho='sudo -E chown -R 1000:1000'
alias datestamp='date +%Y%m%d-%H%M'
alias dd='dd status=progress bs=100M conv=fsync'
alias df='df -x squashfs -x tmpfs -x devtmpfs'
alias disks="sudo fdisk -l 2>/dev/null | grep GiB | sed 's|^.*/d|/d|g; s|:||g; s|GiB.*$|GiB|g; s| \+|\t|g'"
# alias em='emacs -nw'
# alias fuck='TF_CMD=$(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 TF_SHELL_ALIASES=$(alias) thefuck $(fc -ln -1)) && eval $TF_CMD && history -s $TF_CMD'
# alias fucking='sudo'
alias hosts='cat /etc/hosts'
alias his='history | sed -r "s|^[[:blank:]]*[[:digit:]]*[[:blank:]]+||"'
alias l='ls -CF' 
alias la='ls -lha'
alias ll='ls -lh'
alias please='sudo'
# alias reboot='sl'
# alias Reboot='systemctl reboot'
alias stamp='if [ -n "${PGR_DATESTAMP}" ]; then unset PGR_DATESTAMP; else export PGR_DATESTAMP=1; fi'
alias shcon='source /usr/local/bin/sshconnect.sh'

function _git_pullpush_(){
    operation=$1
    BRANCH=$(git branch --show-current); 
    echo GIT: $operation origin $BRANCH; 
    if $(git_status_numeric); then
        sleep 1; 
        trap "echo operation failed; return 1" ERR
        git $operation origin ${BRANCH}
        echo $operation
        git $operation --tags
        echo $?
        return 0
    else
        echo Branch $BRANCH is not commited\; operation aborted
        return 1
    fi
}

alias gish='_git_pullpush_ push'
alias gill='_git_pullpush_ pull'

alias vin='code-insiders'
