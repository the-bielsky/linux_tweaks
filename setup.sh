#!/bin/bash
PGR_EXTENSIONS_FILE="resources/pgr_extensions_to_bashrc.sh"
rsync -r sys_files/etc/* /etc/
rsync -r sys_files/usr/* /usr/

for user in `ls -1 /home/`, root; do
    prefix="home"
    if [ "$user" == "root" ]; then
        prefix=""
    fi
    echo -e "Updating /${prefix}/$user"
    su -c "rsync -ar sys_files/etc/skel/ /${prefix}/$user/" $user
done

user=root
echo -e "Updating /$user"
rsync -ar sys_files/etc/skel/ /$user/

for user in `ls -1 /home/` /root; do
    prefix="home"
    if [ "$user" == "root" ]; then
        prefix=""
    fi
    BASHRC="/${prefix}/$user/.bashrc"
    if [ -f "$BASHRC" ]; then
        # Remove lines between PGR_EXTENSIONS and PGR_EXTENSIONS_&
        sed -i '/--- PGR_EXTENSIONS ---/,/--- PGR_EXTENSIONS_& ---/d' "$BASHRC"
        
        # copy lines between PGR_EXTENSIONS and PGR_EXTENSIONS_& from PGR_EXTENSIONS_FILE to .bashrc
        if [ -f ${PGR_EXTENSIONS_FILE} ]; then
            sed -n '/--- PGR_EXTENSIONS ---/,/--- PGR_EXTENSIONS_& ---/p' ${PGR_EXTENSIONS_FILE} >> "$BASHRC"
        else
            echo "${PGR_EXTENSIONS_FILE} not found" >&2
            echo "Please copy the lines between PGR_EXTENSIONS and PGR_EXTENSIONS_& from ${PGR_EXTENSIONS_FILE} to $BASHRC" >&2
        fi
    fi
done

