#!/bin/bash

#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
B="\e[34m"
N="\e[0m"
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2...failure"
        exit 1
    else
        echo -e "$2...$B success $N"
    fi    

}

if [ $USERID -ne 0 ]
then
    echo "please run this script with root access"
    exit 1  # manually exit if error comes.
else
    echo "you are super user"
fi

sudo apt remove mysql-server -y &>>$LOGFILE

VALIDATE $? "installing mysql"

apt install git -y &>>$LOGFILE

VALIDATE $? "installing git"