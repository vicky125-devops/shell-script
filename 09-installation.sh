#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "please run this script with root access"
    exit 1  # manually exit if error comes.
else
    echo "you are super user"
fi

apt install docker-io -y

if [ $? -ne 0 ]
then
    echo "installation of docker is failure"
    exit 1
else
    echo "Installation success"    
fi    