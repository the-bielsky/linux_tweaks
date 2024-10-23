# --- PGR_EXTENSIONS ---
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
# --- PGR_EXTENSIONS_& ---