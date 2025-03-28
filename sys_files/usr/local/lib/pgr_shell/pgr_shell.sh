#!/bin/bash

# exit if this file is not sourced but run
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "This script is meant to be sourced, not run directly."
    echo "Run 'source $BASH_SOURCE' instead."
    exit 1
fi
THIS_FILENAME="${BASH_SOURCE[0]}"

get_same_dir_files(){
    # list all file of the same directory as the script
    local file_dir=$(dirname "${BASH_SOURCE[0]}")
    for file in $file_dir/*.sh; do
        [[ $file =~ ^_ ]] || echo $file
    done
}

pgr_help() {
    echo
    echo "PGr shell commands"
    echo
    # echo "pgr_help:    Show this help"
    # echo "pgr_git_backup:    Backup all repositories of the owner to the backup_dir"
    # echo "pgr_metabase_api:    Metabase API helpers"
    for line in $(get_same_dir_files); do
        filename=$(echo $line | sed 's|^.*/||')
        echo file: $filename
        pgr_ifc_format_help $line
    done
    echo
}

for filename in $(get_same_dir_files); do
    if [ "$filename" == "$THIS_FILENAME" ]; then
        continue
    fi
    # echo -e "Sourcing $filename"
    source $filename
done

if [ ${PGR_SHELL_LOADED:-0} -ne 1 ]; then
    echo $PGR_SHELL_LOADED
    echo -e "PGr shell commands loaded; Use \033[32mpgr_help\033[0m for more info"
    export PGR_SHELL_LOADED=1
fi


# function immhelp() {
#     # immhelp - print this help
#     echo "Immensus shell commands"
#     echo "Read from ${BASH_SOURCE[0]}"
#     echo -e "\nAvailable shell commands for immensus:"
#     echo "-----------------------"
#     get_help_lines
#     pgr_ifc_format_help "${BASH_SOURCE[0]}"


# }