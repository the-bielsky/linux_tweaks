#!/bin/bash

export PGR_BACKUP_DIR=/srv/local_backup
if [ ! -f $PGR_BACKUP_DIR ]; then
    mkdir -p $PGR_BACKUP_DIR
fi

function pgr_create_base_backup_filename(){
    # pgr_create_base_backup_filename <filename> [backup_dir] - create a filename with date and time as suffix; filename is a full path; default backup_dir: PGR_BACKUP_DIR
    local filename="$1.$(date +%Y%m%d_%H%M)"
    local backup_dir=${2:-$PGR_BACKUP_DIR}
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

function pgr_find_empty_filename(){
    # pgr_find_empty_filename [filename] - appends a incremental number to the filename if given file already exists
    local filename="$1"
    local cnt=0
    out_file="${filename}"
    while [ -f "$out_file" ]; do
        out_file="${filename}.${cnt}"
        cnt=$((cnt+1))
    done
    echo $out_file
}

function pgr_backup_file {
    # pgr_backup_file <filename> - backup a file to the backup directory; adds a date and time suffix to the filename; if the file already exists, adds an incremental number to the filename
    if [ ! -f $1 ]; then
        echo "File $1 not found" >&2
        return 1
    fi
    input_file="$1"
    OUT_FILE=$(pgr_create_base_backup_filename "${input_file}")
    out_file=$(pgr_find_empty_filename "${OUT_FILE}")
    cnt=0
    trap "echo 'Backup failed' >&2; return 1" ERR
    cp "${input_file}" "${out_file}"
    trap - ERR
    echo "Backup of ${input_file} saved to $out_file" >&2
    return 0
}

function pgr_pg_dump {
    # pgr_pg_dump <compose_container> <db_user> <db_name> - backup a PostgreSQL database to a file; adds a date and time suffix to the filename; if the file already exists, adds an incremental number to the filename
    container=$1
    db_user=$2
    db_name=$3
    backup_filename=$(pgr_create_base_backup_filename ${db_name}.sql.gz)
    trap "echo 'Backup failed' >&2; return 1" ERR
    echo "Backing up $db_name to $backup_filename" >&2
    docker compose exec ${container} pg_dump -U $db_user $db_name | gzip > ${backup_filename}
    trap - ERR
}

