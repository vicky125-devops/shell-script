#!/bin/bash

SOURCE_DIRECTORY=/tmp/app-logs

R="\e[31m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

if [ -d $SOURCE_DIRECTORY ]
then
    echo -e "$Y source dir exists $N"
else
    echo -e "$B $SOURCE_DIRECTORY doesn't exits, please make sure $N"
    exit 1
fi

FILES=$(find $SOURCE_DIRECTORY -name "*.log" -mtime +18)

echo "files to delete: $FILES"

while IFS= read -r line
do
  echo "Deleting file: $line"
  rm -rf $line
done <<< $FILES