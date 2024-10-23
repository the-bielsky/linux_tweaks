#!/bin/bash
rsync -r sys_files/etc/* /etc/
rsync -r sys_files/usr/* /usr/

for user in `ls -1 /home/`; do
    su -c "rsync -ar sys_files/etc/skel/ /home/$user/" $user
done




# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#     for COLORS_FILE in ~/.bash_pgr_colors.sh /etc/bash_pgr_colors.sh; do
#         if [ -f ${COLORS_FILE} ]; then
#             . ${COLORS_FILE}
#             break
#         fi
#     done
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi

# SRC=$PWD/sys_files/usr/local/bin/
# ls $SRC
# DST=/usr/local/bin/

# for i in $(ls $SRC); do
#     if [ -e  $SRC/$i ]; then
#         ln -s $SRC/$i $DST/
#     else 
#         echo $i not found
#     fi
# done
