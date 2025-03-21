#!/bin/bash
PGR_EXTENSIONS_FILE="resources/pgr_extensions_to_bashrc.sh"
rsync -r sys_files/etc/* /etc/
rsync -r sys_files/usr/* /usr/

for user in `ls -1 /home/` root; do
    prefix="/home"
    echo -e "Updating ${prefix}/$user"
    if [[ "$user" == "root" ]]; then
        prefix=""
    fi
    su -c "rsync -r sys_files/etc/skel/ /${prefix}/$user/" $user
    BASHRC="/${prefix}/$user/.bashrc"
    if [ -f ${PGR_EXTENSIONS_FILE} ]; then
        :
    else
        echo -e "file: ${PGR_EXTENSIONS_FILE} not found"
        echo -e "bashrc: ${BASHRC} not updated automatically"
        echo -e "Please copy the lines between PGR_EXTENSIONS and PGR_EXTENSIONS_& from ${PGR_EXTENSIONS_FILE} to $BASHRC"
        continue
    fi
    if [ -f "$BASHRC" ]; then
        echo -e "Updating ${BASHRC}"
        # Remove lines between PGR_EXTENSIONS and PGR_EXTENSIONS_&
        sed -i '/--- PGR_EXTENSIONS ---/,/--- PGR_EXTENSIONS_& ---/d' "$BASHRC"
        # copy lines between PGR_EXTENSIONS and PGR_EXTENSIONS_& from PGR_EXTENSIONS_FILE to .bashrc
        if [ -f ${PGR_EXTENSIONS_FILE} ]; then
            sed -n '/--- PGR_EXTENSIONS ---/,/--- PGR_EXTENSIONS_& ---/p' ${PGR_EXTENSIONS_FILE} >> "$BASHRC"
        else
            echo "${PGR_EXTENSIONS_FILE} not found" >&2
            echo "Please copy the lines between PGR_EXTENSIONS and PGR_EXTENSIONS_& from ${PGR_EXTENSIONS_FILE} to $BASHRC" >&2
        fi
    else
        echo "${BASHRC} not found" >&2
    fi
done

