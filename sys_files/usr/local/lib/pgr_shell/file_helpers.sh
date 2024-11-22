#!/bin/bash

export PGR_BACKUP_DIR=/srv/local_backup
if [ ! -f $PGR_BACKUP_DIR ]; then
    mkdir -p $PGR_BACKUP_DIR
fi

function pgr_create_base_backup_filename(){
    local filename="$1.$(date +%Y%m%d%H%M)"
    if [ -n ${PGR_BACKUP_DIR} ]; then
        if [ -d ${PGR_BACKUP_DIR} ]; then
            local OUT_FILE="${PGR_BACKUP_DIR}/$filename"
        else
            echo "Backup directory ${PGR_BACKUP_DIR} not found" >&2
            return 1
        fi
    else
        local OUT_FILE="${filename}"
    fi
    echo $OUT_FILE
}


function pgr_find_empty_filename()
{
    local filename="$1"
    local cnt=0
    OUT_FILE=$(pgr_create_base_backup_filename)
    out_file="${OUT_FILE}"
    while [ -f "$out_file" ]; do
        out_file="${OUT_FILE}.${cnt}"
        cnt=$((cnt+1))
    done
    echo $out_file
}

function pgr_backup_file {
    if [ ! -f $1 ]; then
        echo "File $1 not found" >&2
        return 1
    fi
    cnt=0
    
    out_file=$(pgr_find_empty_filename "$OUT_FILE")
    trap "echo 'Backup failed' >&2; return 1" ERR
    cp "$1" "${out_file}"
    trap - ERR
    echo "Backup of $1 saved to $out_file" >&2
    return 0
}

function pgr_pg_dump {
    container=$1
    db_user=$2
    db_name=$3
    backup_filename=$(pgr_create_base_backup_filename ${db_name}.sql.gz)
    trap "echo 'Backup failed' >&2; return 1" ERR
    echo "Backing up $db_name to $backup_filename" >&2
    docker compose exec ${container} pg_dump -U $db_user $db_name | gzip > ${backup_filename}
    trap - ERR
}

