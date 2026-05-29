
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

. /usr/local/lib/pgr_shell/pgr_shell.sh

# # VARIABLES FOR PGR_EXTENSIONS:
# export PGR_BACKUP_DIR=      # For local backups
# export PGR_GIT_BACKUP_DIR=  # For git(hub) backups
# export PGR_REPO_OWNER=      # For github backups; may be set in github_backup.conf of backup directory

