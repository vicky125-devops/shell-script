#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

PACKAGES=("mysql-server")

#validate function for command is success or failed
VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 is...$R failed $N"
        exit 1
    else
        echo -e "$2 is...$B success $N"
    fi        
}

#skip if package is already installed, if not proceed to installation
installation_check(){
    local package_name="$1"
    echo -e "package to install: $Y $package_name $N"
    if dpkg-query -W --showformat='${Status}\n' "$package_name" 2>/dev/null | grep "install ok installed" &>>$LOGFILE;
    then
        echo -e "package is already installed...$Y SKIPPING $N"
    else
        echo -e "installing package: $Y $package_name $N"
        apt install $package_name -y &>>$LOGFILE
        VALIDATE $? "mysql installation"
    fi         
}


# make sure the the script is running as super user
if [ $USERID -ne 0 ]
then
    echo -e "$R run the script as a super user $N"
else
    echo -e "$Y you are a super user $N"
fi

echo "please emter db password:"
read -s mysql_root_password

for package_name in "${PACKAGES[@]}"
do
  installation_check "$package_name"
done

systemctl enable mysql &>>$LOGFILE
VALIDATE $? "starting mysql server"

systemctl start mysql &>>$LOGFILE
VALIDATE $? "starting mysql"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "starting MYSQL server"

# Below code will be useful for idempotent nature
mysql -h db.daws78s.online -uroot -pread -s ${mysql_root_password} -e 'show databases;' &>>$LOGFILE
exit 1
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass read -s ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MYSQL root password setup"
else
    echo -e "mysql root password is already setup...$Y SKIPPING $N"
fi        


