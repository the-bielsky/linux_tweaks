#!/bin/bash

function pgr_git_is_clean() {
    # pgr_git_is_clean [directory] - check repo is clean; if not: echo '-dirty' and return 1; massage may by changed by variable _pgr_errormsg
    local cur_dir="${1:-$PWD)}"
    local message=${_pgr_errormsg:-dirty}
    # # DEBUG
    # cur_dir=${PWD}
    # cur_dir=/home
        
    # Check if the directory is a git repository
    if ! git -C "${cur_dir}" rev-parse --is-inside-work-tree &>/dev/null; then
        # echo -e "Git in '${cur_dir}' is not a git repo or can't read it" >&2
        echo "-no-repo-"
        return 1
    fi
    local res=$(git -C "${cur_dir}" status --porcelain | wc -l)
    # Check if there are any changes
    if [ "$res" -eq 0 ]; then
        # echo -e "Git in '${cur_dir}' is clean" >&2
        return 0
    else
        # echo -e "Git in '${cur_dir}' is not clean" >&2
        echo -e "${message}"
        return 1
    fi
    
    # res=$(git -C "${cur_dir}" status  --porcelain)
    # if [ "$?" -ne 0 ]; then
    #     echo -e "Git in '${cur_dir}' is not a git repoo or can't read it" >&2
    #     echo "-no-repo-"
    #     return 1
    # fi
    # echo "$res" | wc -l
    # res=$(echo "$res" | wc -l)
    # echo "$res"
    # if [ "$res" -eq 0 ]; then
    #     echo -e "Git in '${cur_dir}' is clean" >&2
    #     return 0
    # else
    #     echo -e "Git in '${cur_dir}' is not clean" >&2
    #     echo -e "${message}"
    #     return 1
    # fi
}

function pgr_git_is_repo() {
    # pgr_git_is_repo [directory] - check if directory is within range of a git repo;
    local cur_dir="${1:-$(pwd)}"
    git -C "${cur_dir}" rev-parse --is-inside-work-tree 2>/dev/null
}

function pgr_git_repo_version() {
    # pgr_git_repo_version [directory] - print the version of git repo inside directory; default is current dir;
    local cur_dir="${1:-$(pwd)}"
    is_clean=$(_pgr_errormsg='-dirty' pgr_git_is_clean "${cur_dir}")
    local ver=$(git -C "${cur_dir}" describe --tags --abbrev=4 2>/dev/null)
    echo "${ver}${is_clean}"
}

