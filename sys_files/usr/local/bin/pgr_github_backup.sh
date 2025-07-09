#!/bin/bash

help(){
    echo "
Usage: $0 [backup_dir]

Backup all repositories of the owner to the backup_dir

Arguments:
    backup_dir:    directory where the repositories will be cloned
                   If backup_dir is not provided, use env variable PGR_GIT_BACKUP_DIR
                   Then if PGR_GIT_BACKUP_DIR is not set, use current directory
Config file:
    github_backup.conf must exist in backup_dir.
    This file may be empty or contain the variable PGR_REPO_OWNER
    Repo owner is the github user or organization
    Variable PGR_REPO_OWNER may also be provided as exported shell variable
    Variable has higher priority than config value, but config file must exist
    Variable may contain multiple owners separated by space, e.g.:
         export PGR_REPO_OWNER=(repo_owner1 repo_owner2)

REQUIREMENTS:
    - gh (github cli) 
    - jq (json parser)

gh cli must be authorized with syntax:
gh auth login
"
}

PGR_GIT_BACKUP_DIR=${1:-$PGR_GIT_BACKUP_DIR}  # Directory where the repositories will be cloned

if [ -z "$PGR_GIT_BACKUP_DIR" ]; then
    PGR_GIT_BACKUP_DIR=$(pwd)
fi
CONFIG_FILE="$PGR_GIT_BACKUP_DIR/github_backup.conf"

if [ -z "$PGR_REPO_OWNER" ]; then
    source "$PGR_GIT_BACKUP_DIR/github_backup.conf"
fi
if [ -z "$PGR_REPO_OWNER" ]; then
    help
    echo
    echo "Error: repo owner is not provided"
    exit 1
fi

# Check if file github_backup/github_backup.conf exists
if [ ! -f "${CONFIG_FILE}" ]; then
      help
      echo
      echo -e "File ${CONFIG_FILE} does not exist"
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
for owner in ${PGR_REPO_OWNER[@]}; do
    echo -------------------------------------------------------------------------------
    echo -e "Cloning repositories of $owner to $PGR_GIT_BACKUP_DIR"
    for repo in $(gh repo list $owner --json name,diskUsage --jq '.[] | "\(.name    )"'); do
        repo_dir="$PGR_GIT_BACKUP_DIR/$owner-$repo.git"
        echo ------------ cloning $repo ------------
        trap 'echo Repo cloning error; ERRCNT=$((ERRCNT+1)); continue' ERR
        if [ -d "$repo_dir" ]; then
            echo "Repository $repo already exists (updating)"
            trap 'echo Repo cloning error; ERRCNT=$((ERRCNT+1)); continue' ERR
            git -C "$repo_dir" fetch --all
            git -C "$repo_dir" remote update
            echo "Repository $repo updated"
        else
            trap 'echo Repo cloning error; ERRCNT=$((ERRCNT+1)); continue' ERR
            gh repo clone "${owner}/$repo" "$repo_dir" -- --mirror
        fi
        trap - ERR
    done
done
trap - ERR
if [ $ERRCNT -gt 0 ]; then
    echo "There were $ERRCNT error(s) during cloning the repositories"
    exit 1
else
    echo "All repositories cloned successfully"
    exit 0
fi