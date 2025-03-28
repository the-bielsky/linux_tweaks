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
    # check if file contains NO_INSTALL_PGR_EXTENSIONS and skip if found
    if grep -q "NO_INSTALL_PGR_EXTENSIONS" ${BASHRC}; then
        echo -e "NO_INSTALL_PGR_EXTENSIONS found in ${BASHRC}"
        echo -e "bashrc: ${BASHRC} not updated automatically"
        continue
    fi
    # check if file contains --- PGR_EXTENSIONS --- 
    if grep -Eq "\-\-\- PGR_EXTENSIONS ---" ${BASHRC}; then
        :
    else
        :
        echo "# --- PGR_EXTENSIONS ---" >> ${BASHRC}
        echo "# --- PGR_EXTENSIONS_& ---" >> ${BASHRC}
    fi

    if [ -f "$BASHRC" ]; then
        sed -i '/--- PGR_EXTENSIONS ---/,/--- PGR_EXTENSIONS_&/{//!d}' ${BASHRC} 
        sed -i -s '/--- PGR_EXTENSIONS ---/r '${PGR_EXTENSIONS_FILE} ${BASHRC}
    else
        echo "${BASHRC} not found" >&2
    fi
    # Replace line starting with VERSION= in /usr/local/lib/pgr_shell/pgr_shell.sh with the pgrshell_version
done
source sys_files/usr/local/lib/pgr_shell/pgr_shell.sh
cur_dir=$(dirname "$0")
echo $cur_dir
pgrshell_version=$(pgr_shell_version "$cur_dir")
echo   $pgrshell_version
sed -i "s/^PGR_SHELL_VERSION=.*/PGR_SHELL_VERSION=\"${pgrshell_version}\"/" /usr/local/lib/pgr_shell/pgr_shell.sh

