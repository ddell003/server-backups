#!/bin/bash

# place this file on the server with the mongo db client
# place it in /user/bin
# set up crontab
# 10 03   * * *   root    cd /backups/mongo &&  /bin/bash /usr/bin/backupmongo.sh >> /var/log/backupmongo.log

# without trailing slash
OUTPUT_DIR=/backups/mongo

# check to see if the directory exists, if it doesn't, make the directory
[ -d $OUTPUT_DIR ] || mkdir -p $OUTPUT_DIR

mongodump --db ecompliance_production -o $OUTPUT_DIR
