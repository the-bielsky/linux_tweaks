#!/bin/bash

# This script is used to backup the github repositories to the local machine.
# The script will clone the repositories to the local machine
# requires installed gh (github cli) and jq (json parser)
# gh cli must be authorized with syntax:
# gh auth login

# $1 must be provided as the first argument

help(){
    echo
    echo "Usage: $0 <repo_owner> [backup_dir]"
    echo
    echo "Backup all repositories of the owner to the backup_dir"
    echo
    echo "repo_owner:    github username or organization; should be provided as a env variable PGR_REPO_OWNER"
    echo "backup_dir:    directory where the repositories will be cloned"
    echo "If backup_dir is not provided, the repositories will be cloned to the current directory"
    echo
    echo "There must be a file github_backup.conf in the aaa directory (can be empty);"
}

PGR_REPO_OWNER=${1:-$PGR_REPO_OWNER}  # Owner of the repositories (user of github/organization)
PGR_BACKUP_DIR=${2:-$PWD}  # Directory where the repositories will be cloned
CONFIG_FILE="$PGR_BACKUP_DIR/github_backup.conf"

# Check if file github_backup/github_backup.conf exists
if [ ! -f "${CONFIG_FILE}" ]; then
      help
      echo
      echo -e "File ${CONFIG_FILE} does not exist"
      exit 1
fi

if [ -z "$PGR_REPO_OWNER" ]; then
    help
    echo
    echo "Error: repo owner is not provided"
    exit 1
fi
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    help
    exit 0
fi

ERRCNT=0


trap 'echo Error!; ERRCNT=$((ERRCNT+1)); exit 1' ERR
# Healthcheck; statement in the loop doesnt generate error if gh repo list has error
res=$(gh repo list $PGR_REPO_OWNER)
# echo $res
# gh repo list solution-sca --json name,diskUsage --jq '.[] | "\(.name)"' | wc -l

for repo in $(gh repo list $PGR_REPO_OWNER --json name,diskUsage --jq '.[] | "\(.name)"'); do
    echo ------------ cloning $repo ------------
    trap 'echo Repo cloning error; ERRCNT=$((ERRCNT+1)); continue' ERR
    repo_dir="$PGR_BACKUP_DIR/$repo.git"
    if [ -d "$repo_dir" ]; then
        echo "Repository $repo already exists (updating)"
        trap 'echo Repo cloning error; ERRCNT=$((ERRCNT+1)); continue' ERR
        git -C "$repo_dir" fetch --all
        git -C "$repo_dir" remote update
        echo "Repository $repo updated"
    else
        trap 'echo Repo cloning error; ERRCNT=$((ERRCNT+1)); continue' ERR
        gh repo clone "${PGR_REPO_OWNER}/$repo" -- --mirror
    fi
    trap - ERR
done
trap - ERR
if [ $ERRCNT -gt 0 ]; then
    echo "There were $ERRCNT error(s) during cloning the repositories"
    exit 1
else
    echo "All repositories cloned successfully"
    exit 0
fi