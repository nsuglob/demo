#!/bin/bash
#----------DIRS--------------
LOG_DIR=/var/log/nginx;
#----------LOGS--------------
ACCESS_LOG=access.log;
ERROR_LOG=error.log;
COMMON_LOG=common.log;
CLEANUP_LOG=cleanup.log;
CLIENT_ERROR_LOG=client.log;
SERVER_ERROR_LOG=server.log;

FILE_LIMIT=30000;

echo "----CLEANING PREVIOUS LOGS----";
echo > $LOG_DIR/$COMMON_LOG;
echo > $LOG_DIR/$CLIENT_ERROR_LOG;
echo > $LOG_DIR/$SERVER_ERROR_LOG;
echo > $LOG_DIR/$ACCESS_LOG;
echo > $LOG_DIR/$ERROR_LOG;

echo "Waiting for new logs.";

while :; 
do
LOG_SIZE=$(wc -c $LOG_DIR/$COMMON_LOG | awk '{print $1}');
  if [[ $LOG_SIZE -lt $FILE_LIMIT ]]; then
    echo "---------------------------";
    echo "Logs size is $LOG_SIZE kb.";
    echo $(date);
    cat $LOG_DIR/$ACCESS_LOG $LOG_DIR/$ERROR_LOG > $LOG_DIR/$COMMON_LOG;
    awk '/400/;/404/;/414/' $LOG_DIR/$COMMON_LOG > $LOG_DIR/$CLIENT_ERROR_LOG;
    awk '/500/;/503/' $LOG_DIR/$COMMON_LOG > $LOG_DIR/$SERVER_ERROR_LOG;
  else
    CLEANUP_DATE=$(date);
    echo > $LOG_DIR/$COMMON_LOG;
    echo > $LOG_DIR/$ACCESS_LOG;
    echo > $LOG_DIR/$ERROR_LOG;
    echo "$COMMON_LOG was cleaned at $CLEANUP_DATE" >> $LOG_DIR/$CLEANUP_LOG;
    echo "Cleanup is done. Latest cleanup date is: $CLEANUP_DATE"
  fi
sleep 5;
done
