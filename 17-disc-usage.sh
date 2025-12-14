#!/bin/bash

DISK_USAGE=$(df -hT | grep /dev/nvme0n1)
DISK_THRESHOLD=1

while IFS= read -r line
do
  USAGE=$(echo $line | awk -F " " '{print $6F}' | cut -d "%" -f1)
  FOLDER=$(echo $line | awk -F " " '{print $NF}')
  if [ $USAGE -ge $DISK_THRESHOLD ]
  then
      MESSAGE+="$FOLDER is more than $DISK_THRESHOLD, current usage: $USAGE \n"
  fi
done <<< $DISK_USAGE

echo -e "Message: $MESSAGE"

echo -e "$MESSAGE" | mail -s "Disk Usage Alert" rajimylove1@gmail.com

# echo "body" | mail -s "subject" to-address
