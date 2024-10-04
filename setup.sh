#!/bin/bash
rsync -r sys_files/etc/* /etc/
rsync -r sys_files/usr/* /usr/

for user in `ls -1 /home/`; do
    su -c "rsync -ar sys_files/etc/skel/ /home/$user/" $user
done

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
