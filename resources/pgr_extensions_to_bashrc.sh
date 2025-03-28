
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [ "$color_prompt" = yes ]; then
    for COLORS_FILE in ~/.bash_pgr_colors.sh /etc/bash_pgr_colors.sh; do
        if [ -f ${COLORS_FILE} ]; then
            . ${COLORS_FILE}
            break
        fi
    done
    export VIRTUAL_ENV_DISABLE_PROMPT=1
fi
unset color_prompt
for ALIAS_FILE in ~/.bash_pgr_aliases.sh /etc/bash_pgr_aliases.sh; do
    if [ -f ${ALIAS_FILE} ]; then
        . ${ALIAS_FILE}
        break
    fi
done
# for filename in docker_helpers.sh script_helpers.sh script_interface.sh file_helpers.sh metabase_api_helpers.sh; do
for filename in /usr/local/lib/pgr_shell/*.sh; do
    if [[ "$filename" =~ _\.sh$ ]]; then
        continue
    fi
    source ${filename}
done

. /usr/local/lib/pgr_shell/pgr_shell.sh

# # VARIABLES FOR PGR_EXTENSIONS:
# export PGR_BACKUP_DIR=      # For local backups
# export PGR_GIT_BACKUP_DIR=  # For git(hub) backups
# export PGR_REPO_OWNER=      # For github backups; may be set in github_backup.conf of backup directory

