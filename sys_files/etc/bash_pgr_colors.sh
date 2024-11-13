set -a
fg_off=$(tput sgr0)
format_off=$(tput sgr0)
fg_default="\e[39m"
fg_black=$(tput setaf 0)
fg_red=$(tput setaf 1)
fg_green=$(tput setaf 2)
fg_yellow=$(tput setaf 3)
fg_blue=$(tput setaf 4)
fg_magenta=$(tput setaf 5)
fg_cyan=$(tput setaf 6)
fg_white=$(tput setaf 7)
fg_gray=$(tput setaf 8)
fg_brown=$(tput setaf 94)
fg_orange=$(tput setaf 208)
fg_amber=$(tput setaf 136)
fg_navy=$(tput setaf 18)
#fg_amber=$(tput setaf 214)
bg_blue=$(tput setab 4)
bg_red=$(tput setab 1)
bg_burowy=$(tput setab 236)
fg_rev=$(tput rev)
set +a

username_color=${fg_white}
if [ ${UID} -eq 0 ]; then
    username_color=${fg_red}
fi

# USER AND HOSTNAME PRESENTATION
# Colors for hostname types
function ps1_user_and_hostname(){
    hostname_color=${fg_green}
    username_color=${fg_white}
    if [[ ${EUID} == 0 ]]; then 
        # echo -e "\[${fg_red}\]root@"
        hostname_color=${fg_red}
        username_color=${fg_red}
    fi
    if $(command -v vbox-greeter >/dev/null 2>&1); then
        hostname_color=${fg_amber}
    elif [[ "$(hostname)" =~ ^imm- ]]; then
        hostname_color=${fg_orange}
    elif [[ "$(hostname)" =~ ^immdev- ]]; then
        hostname_color=${fg_gray}
    elif [[ -n "${SSH_CLIENT}" ]]; then
        hostname_color=${fg_cyan}
    fi

    echo -e "${username_color}\\u${fg_amber}@${hostname_color}\\h"
}

buf=fg_${NETNS//-/_}
ns_colour=${!buf}
ns_colour="${ns_colour:-${fg_amber}}"
#`p1 10.0.2.140`

function is_vpn_connection(){
    ip link show dev tun0 2>/dev/null | grep -c LOWER_UP
}

# Function to get the current Git branch name
function git_branch {
  res=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  printf "${res}"
}

# Function to check if the Git status is clean
function git_status {
  if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
    printf "${fg_red}"  # Red color
  else
    printf "${fg_amber}"  # Green color
  fi
}

# function git_describe {
#   git describe --tags --always
# }

# # Function to check if the current directory is a Git repository
# function is_git_repo {
#   if $(git rev-parse --is-inside-work-tree &>/dev/null); then
#     echo -e "─${fg_red}($(git_status)$(git_branch)${fg_red}/$(git_status)$(git_describe)${fg_red})"
#   else
#     return
#   fi
# }


# upper-left corner"
# ┌─[root@przemekg]─[linux_tweaks]
# └── # 

# shellcheck disable=2154
# Bez zamknięcia nazw kolorów w \[${nazwa}\] PS1 działa, ale rozwala się przewijanie historii strzałką (dziwne rzeczy, gdy po dłuższym tekscie jest krótszy)
# \$(git_status) runs every usage; $(git_status) runs once 
# --- PGR_EXTENSIONS_& ---

PS1="\[${fg_red}\]┌\$([[ \$? != 0 ]] && echo \"─[\342\234\227\[\033[0;37m\]${fg_red}]\")\
\$( [ -n \"\${VIRTUAL_ENV_PROMPT}\" ]  &&  echo \"─[\[${fg_amber}\]poetry: \${VIRTUAL_ENV_PROMPT}\[${fg_red}\]]\")\
─[$(ps1_user_and_hostname)\[${fg_red}\]]\
\$( [ -n \"${NETNS}\" ]  &&  echo \"─[\[${ns_colour}\]netns \${NETNS}\[${fg_red}\]]\"    )\
\$( [ -n \"\${tag}\" ]  &&  echo \"─[\[${fg_amber}\]tag \${tag}\[${fg_red}\]]\"    )\
\$( [ -n \"\${build}\" ]  &&  echo \"─[\[${fg_amber}\]build \${build}\[${fg_red}\]]\"    )\
─[${fg_amber}\w\[${fg_red}\]]\n\[${fg_red}\]└\
\$( [ -n \"\${PGR_DATESTAMP}\" ]  &&  echo \"─[\[${fg_amber}\]\$(date +\%Y-\%m-\%d-\%H:\%M:\%S)\[${fg_red}\]]\")\
\$( [ -n \"\${PPJ1_CLIGRP}\" ]  &&  echo \"─[\[${fg_amber}\]voipgrp \${PPJ1_CLIGRP}\[${fg_red}\]]\"    )\
\$( [ -n \"\${ipaddr}\" ]  &&  echo \"─[\[${fg_amber}\]ipaddr \${ipaddr}\[${fg_red}\]]\"    )\
\$( [ -n \"\$(git_branch)\" ]  &&  echo \"─[\[\$(git_status)\]git: \$(git_branch)\[${fg_red}\]]\")\
\$( [ \"\$(is_vpn_connection)\" -eq 1 ]  &&  echo \"─[\[${fg_red}\]VPN]\"    )\
─ \[\033[0m\]\[\e[01;33m\]\\$\[\e[0m\] "

# Set 'man' colors
man() {
env \
LESS_TERMCAP_mb=$'\e[01;31m' \
LESS_TERMCAP_md=$'\e[01;31m' \
LESS_TERMCAP_me=$'\e[0m' \
LESS_TERMCAP_se=$'\e[0m' \
LESS_TERMCAP_so=$'\e[01;44;33m' \
LESS_TERMCAP_ue=$'\e[0m' \
LESS_TERMCAP_us=$'\e[01;32m' \
man "$@"
}
