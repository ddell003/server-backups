#!/bin/bash

$DIR='/mnt/db_backups'

for f in DIR/*; do
    if [[ -d $f ]]; then
        # $f is a directory
	echo ${f};
    fi
done

