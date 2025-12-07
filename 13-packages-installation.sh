#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
B="\e[34m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
  if [ $1 -ne 0 ]
  then
      echo -e "$2...$R failed $N"
  else
      echo -e "$2...$B success $N"
  fi        
}

if [ $USERID -ne 0 ]
then
    echo "please run the script with root access"
    exit 1
else
    echo "you are super user"
fi

for i in $@
do
  echo "package to install: $i"
  if dpkg-query -W --showformat='${Status}\n' "$i" 2>/dev/null | grep "install ok installed" &>>$LOGFILE;
  then
      echo -e "$i is already installed...$Y SKIPPING $N"
  else
      apt install $i -y &>>$LOGFILE
      VALIDATE $? "installation of $i"
  fi    
done
  