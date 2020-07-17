#!/usr/bin/env bash


# THIS SCRIPT WILL ONLY WORK ON OSX IN ITS CURRENT FORM
# THE DATE AND STAT COMMANDS WORK A LITTLE DIFFERENTLY ON LINUX
# WILL REQUIRE MODIFICATION

#add to array of files to check for
FILES=(test.sql.gz test2.sql.gz)
DIR=/mnt/db_backup/

CUR_STR=$(date "+%m-%d") # good for mac and debian

GO=true

#stat -f "%Sm" -t "%m-%d" file1.txt

for file in "${FILES[@]}"
    do
    	#FILE_STR=$(stat -f "%Sm" -t "%m-%d" $dir$file) # works on mac
    	FILE_STR=$(date -d "@$(stat -c '%Y' $DIR$file)" '+%m-%d') # works on debian

        if test "$FILE_STR" != "$CUR_STR"
            then
                GO=false
		echo "($file) Failed on: $FILE_STR != $CUR_STR"
        fi
done

if test $GO == true
then
# add actual id
    curl https://nosnch.in/1234
    echo "Snitched."
else
    echo "One of the files did not match today's date"
fi

