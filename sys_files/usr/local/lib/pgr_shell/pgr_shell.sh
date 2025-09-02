#!/bin/bash

# exit if this file is not sourced but run
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "This script is meant to be sourced, not run directly."
    echo "Run 'source $BASH_SOURCE' instead."
    exit 1
fi
THIS_FILENAME="${BASH_SOURCE[0]}"
export PGR_SHELL_VERSION="" # setting automatically by setup.sh

pgr_shell_version() {
    # pgr_shell_version - print the version of the pgr shell
    shell_installer_dir=$(dirname "${THIS_FILENAME}")
    pgr_git_repo_version 
}

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
    echo "Version: $PGR_SHELL_VERSION"
    echo
    # echo "pgr_help:    Show this help"
    # echo "pgr_git_backup:    Backup all repositories of the owner to the backup_dir"
    # echo "pgr_metabase_api:    Metabase API helpers"
    for line in $(get_same_dir_files); do
        # skip bash_pgr_aliases.sh and bash_pgr_colors.sh
        if [[ "$line" =~ ^(.*bash_pgr_aliases\.sh|.*bash_pgr_colors\.sh)$ ]]; then
            continue
        fi
        filename=$(echo $line | sed 's|^.*/||')
        echo $filename
        pgr_ifc_format_help $line
        echo
    done
    echo 
    echo Shell variables:
    export | grep PGR | sed 's|^.*PGR_|    PGR_|g'
}

for filename in $(get_same_dir_files); do
    if [ "$filename" == "$THIS_FILENAME" ]; then
        continue
    fi
    # echo -e "Sourcing $filename"
    source $filename
done

if [ ${PGR_SHELL_LOADED:-0} -ne 1 ]; then
    echo -e "PGr shell version: ${PGR_SHELL_VERSION} loaded; Use \033[32mpgr_help\033[0m for more info"
    export PGR_SHELL_LOADED=1
fi


