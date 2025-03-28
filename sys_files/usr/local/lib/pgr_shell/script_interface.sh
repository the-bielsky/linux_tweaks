#!/bin/bash

# ----------------------------------
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[1;30m'
AMBER='\033[0;33m'
NC='\033[0m' # No Color

function pgr_ifc_get_next_lines_after_pattern() {
    # pgr_ifc_get_next_lines_after_pattern <input_file> [pattern] - get next line after pattern. Default: next line after shell function definitions
    local input_file=$1
    local pattern=${2:-"^\W*function\W+[a-zA-Z]"}
    grep -nE "${pattern}" "$input_file" | while IFS=: read -r line_number _; do
        next_line=$((line_number + 1))
        sed -n "${next_line}p" "$input_file"
    done
}
function pgr_ifc_get_help_lines() {
    # pgr_ifc_get_help_lines <input_file> - get next line after function definitions that starts with #
    local input_file="$1"
    pgr_ifc_get_next_lines_after_pattern "${input_file}" | grep -E "^\W*#"
}

function pgr_ifc_format_help() {
    # pgr_ifc_format_help [-v] <input_file> - print formatted help lines; if not verbose trim to terminal width
    # verbose=0
    # for variable in "$@"; do
    #     case $variable in
    #         -v|--verbose)
    #             verbose=1; shift;;
    #         *)  
    #             break;;
    #     esac
    # done
    input_file="$1"
    longest_command_str=0
    while read -r line; do
        command_str=$(echo "$line" | sed 's/ - .*$//')
        cmd_length=$(echo "$command_str" | wc -c)
        if [ $cmd_length -gt $longest_command_str ]; then
            longest_command_str=$cmd_length
        fi
    done < <(pgr_ifc_get_help_lines "${input_file}" | sed -E "s/^\W*# ?//")

    longest_command_str=${longest_command_str:-32}
    if [ $longest_command_str -gt 32 ]; then
        longest_command_str=32
    fi
    
    while read -r line; do
        command_str=$(echo "$line" | sed 's/ - .*$//' )
        cmd_length=$(echo "$command_str" | wc -c)
        help_str=$(echo "$line" | cut -c$((cmd_length+3))-)
        command_str=$(echo "$command_str" | sed 's|^\W*[#]\W*||')
        if [ $cmd_length -gt $longest_command_str ]; then
            space_num=0
        else
            space_num=$((longest_command_str - cmd_length))
        fi
        spaces=$(printf "%*s" $space_num)
        echo -e "    ${AMBER}${command_str}${NC} ${spaces}- ${help_str}${NC}"
        # if [ $verbose -eq 1 ]; then
        #     echo -e "    ${AMBER}${command_str}${NC} ${spaces}- ${help_str}${NC}"
        # else
        #     # terminal_width=$(($(tput cols)-6))
        #     # prints only terminal width number of signs
        #     # echo -e "    ${AMBER}${command_str}${NC} ${spaces}- ${help_str}${NC}"  | sed -E 's|^(.{'${terminal_width}'}).*|\1\(...\)|'
        #     echo -e "    ${AMBER}${command_str}${NC} ${spaces}- ${help_str}${NC}"
        # fi

    done < <(pgr_ifc_get_help_lines "${input_file}" | sed -E "s/^\W*# ?//")
}

shout () {
    # shout <message> - print message in red
    echo -e "$RED$*$NC" >&2
}

dont_shout () {
    # dont_shout <message> - print message in green
    echo -e "$GREEN$*$NC" >&2
}

whisper () {
    # whisper <message> - print message in gray
    echo -e "$GRAY$*$NC" >&2
}

amber_info () {
    # amber_info <message> - print message in amber
    echo -e "$AMBER$*$NC" >&2
}

print_command() {
    # print_command <command> - print Command: and given string in next line
    whisper "${GRAY}Command:$NC"
    whisper "    $@"
}
space_num=2
# space_num times print sign _
print_line() {
    # print_line <number> - I don't remember what this is for :)
        printf "_%*s_" $space_num
}