#!/bin/bash

read -p 'Databases Loading: ' DBLIST
for DB in $DBLIST
do
    echo $DB && date && echo "DROP DATABASE IF EXISTS $DB; CREATE DATABASE $DB;" | mysql -uroot -pirs22952 && mysql -uroot -pirs22952 $DB<sql/$DB.sql && date;
done

