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
    # pgr_get_next_lines <input_file> [pattern] - get next line after pattern. Default: after shel function definitions
    local input_file=$1
    local pattern=${2:-"^\W*function\W+[a-zA-Z]"}
    grep -nE "${pattern}" "$input_file" | while IFS=: read -r line_number _; do
        next_line=$((line_number + 1))
        sed -n "${next_line}p" "$input_file"
    done
}
function pgr_ifc_get_help_lines() {
    # pgr_get_help_lines <input_file> - get next line after function definitions that starts with #
    local input_file="$1"
    pgr_ifc_get_next_lines_after_pattern "${input_file}" | grep -E "^\W*#"
}

function pgr_ifc_format_help() {
    input_file="$1"
    longest_command_str=0
    while read -r line; do
        command_str=$(echo "$line" | sed 's/ - .*$//')
        cmd_length=$(echo "$command_str" | wc -c)
        if [ $cmd_length -gt $longest_command_str ]; then
            longest_command_str=$cmd_length
        fi
    done < <(pgr_ifc_get_help_lines "${input_file}" | sed -E "s/^\W*# ?//")


    if [ $longest_command_str -gt 32 ]; then
        longest_command_str
    fi
    
    while read -r line; do
        command_str=$(echo "$line" | sed 's/ - .*$//' )
        cmd_length=$(echo "$command_str" | wc -c)
        help_str=$(echo "$line" | cut -c$((cmd_length+3))-)
        command_str=$(echo "$command_str" | sed 's|^\W*[#]\W*||')
        space_num=$((longest_command_str - cmd_length))
        spaces=$(printf "%*s" $space_num)
        echo -e "    ${AMBER}${command_str}${NC} ${spaces}- ${help_str}${NC}"
    done < <(pgr_ifc_get_help_lines "${input_file}" | sed -E "s/^\W*# ?//")
}

shout () {
    echo -e "$RED$*$NC" >&2
}

dont_shout () {
    echo -e "$GREEN$*$NC" >&2
}

whisper () {
    echo -e "$GRAY$*$NC" >&2
}

amber_info () {
    echo -e "$AMBER$*$NC" >&2
}

print_command() {
    whisper "${GRAY}Command:$NC"
    whisper "    $@"
}
space_num=2
# space_num times print sign _
print_line() {
        printf "_%*s_" $space_num
}