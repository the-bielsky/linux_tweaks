#!/bin/bash

# ----------------------------------
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[1;30m'
AMBER='\033[0;33m'
NC='\033[0m' # No Color

function pgr_get_next_line_after_function_definitions() {
    # pgr_get_next_line_after_function_definitions <input_file> - get next line after function definitions
    local input_file=$1
    grep -nE "^\W*function\W+[a-zA-Z]" "$input_file" | while IFS=: read -r line_number _; do
        next_line=$((line_number + 1))
        sed -n "${next_line}p" "$input_file"
    done
}
function pgr_get_help_lines() {
    # pgr_get_help_lines <input_file> - get next line after function definitions that starts with #
    local input_file="$1"
    pgr_get_next_line_after_function_definitions "${input_file}" | grep -E "^\W*#"
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