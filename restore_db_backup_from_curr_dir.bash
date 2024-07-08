#!/bin/bash


MYSQL_BIN="/usr/bin/mysql"
GZIP_BIN="/bin/gzip"
CURR_DIR=$(pwd)

DB_HOST="127.0.0.1"
DB_USER="dbusr"
DB_PASSWD="dbpasswd"
DB_NAME="restore_test"



make_restore_db() {
	DUMP_FILE_PATH=$1

	#echo "$GZIP_BIN -d -k -c $DUMP_FILE_PATH | $MYSQL_BIN -h $DB_HOST -u $DB_USER -p$DB_PASSWD $DB_NAME"
	$GZIP_BIN -d -k -c $DUMP_FILE_PATH | $MYSQL_BIN -h $DB_HOST -u $DB_USER -p$DB_PASSWD $DB_NAME
}


FILE_ARRAY=(`/usr/bin/find $CURR_DIR/*.sql.gz | sort`)
ARRLEN=${#FILE_ARRAY[*]}


echo "Src SQL GZIPed files list are:"
i=0
while [ $i -lt $ARRLEN ]; do
	echo "$(($i+1)): ${FILE_ARRAY[$i]}"
	let i++
done

echo
echo "Destination DATABASE: $DB_USER:$DB_PASSWD @ $DB_HOST:$DB_NAME"
echo
read -p "Are you sure to do RESTORE of all GZIPed SQL files from this script folder? [Y/n] "
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Y]$ ]]
then
	echo "Declined. Exiting :("
	exit 254
fi



i=0
while [ $i -lt $ARRLEN ]; do
	echo "$(($i+1)): Restoring ${FILE_ARRAY[$i]} to $DB_HOST:$DB_NAME"
	make_restore_db ${FILE_ARRAY[$i]}
	let i++
done

