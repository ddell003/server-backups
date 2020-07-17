#!/bin/bash

# start the timer
now=$(date +"%D %T")
echo "Started at: $now"
SECONDS=0
LOCALSECONDS=0

GREEN='\033[0;32m'
LIGHTGREEN='\033[1;32m'
NC='\033[0m' # No Color

#location of the finished product
dumpLocation=/mnt/db_backup/

#webserverHost=internalwebserver.mysql.database.azure.com
#webserverUser=einnovativeReporter@internalwebserver
#webserverPword="K7Vag6C!D=)fv#~!03312020"
#declare -a webserverDatabases=("vault" "irtcdatabase" "sop" "lms-legacy" "eintranet")

einnovativeHost=hostName
einnovativeUser=username
einnovativePword="password"
declare -a einnovativeDatabases=("db1" "db2")



#for db in "${webserverDatabases[@]}"
#do
#	STARTTIME=$(date +%s)
#	echo -ne "Dumping ${db} from ${webserverHost} "
#	mysqldump --host=${webserverHost} -u${webserverUser} -p${webserverPword} --quick --single-transaction --verbose ${db} > ${dumpLocation}${db}.sql
#	echo -ne "... ${LIGHTGREEN}done${NC} ... "
#	gzip -9 -f ${dumpLocation}${db}.sql
#	echo -ne "${GREEN}zipped!${NC}"
#	ENDTIME=$(date +%s)
#	echo " ($(($ENDTIME - $STARTTIME))s)"
#done

for db in "${einnovativeDatabases[@]}"
do
        STARTTIME=$(date +%s)
        echo -ne "Dumping ${db} from ${einnovativeHost} "
        mysqldump --host=${einnovativeHost} -u${einnovativeUser} -p${einnovativePword} --quick --single-transaction --verbose --routines ${db} > ${dumpLocation}${db}.sql
        echo -ne "... ${LIGHTGREEN}done${NC} ... "
        gzip -9 -f ${dumpLocation}${db}.sql
        echo -ne "${GREEN}zipped!${NC}"
        ENDTIME=$(date +%s)
        echo " ($(($ENDTIME - $STARTTIME))s)"
done

if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo -e "${GREEN}Overall completed in $hours hour(s), $minutes minute(s) and $seconds second(s)${NC}" 
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo -e "${GREEN}Overall completed in $minutes minute(s) and $seconds second(s)${NC}"
else
    echo -e "${GREEN}Overall completed in $SECONDS seconds${NC}"
fi
