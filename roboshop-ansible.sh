#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp

LOGFILE="$LOGSDIR/roboshop-ansible-$DATE.log"
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}
yum install epel-release -y &>>$LOGFILE
VALIDATE $? "Validate Download Of Extra Packages For Enterprise Linux"
yum install ansible -y &>>$LOGFILE
VALIDATE $? "Validate Download Of Ansible-Server"
cd /tmp
VALIDATE $? "Validate Change Of Directory"
git clone https://github.com/Sarthakx67/RoboShop-Ansible-Roles.git &>>$LOGFILE
VALIDATE $? "Validate Cloning Of Repository"
cd RoboShop-Ansible-Roles
chmod 700 EC2-key.pem
ansible-playbook -i inventory -e component=mongodb main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of MongoDB-Component"
ansible-playbook -i inventory -e component=catalogue main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of Catalogue-Component"
ansible-playbook -i inventory -e component=redis main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of Redis-Component"
ansible-playbook -i inventory -e component=user main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of User-Component"
ansible-playbook -i inventory -e component=cart main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of Cart-Component"
ansible-playbook -i inventory -e component=web-server main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of Web-Component"
ansible-playbook -i inventory -e component=mysql main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of Mysql-Component"
ansible-playbook -i inventory -e component=shipping main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of Shipping-Component"
ansible-playbook -i inventory -e component=rabbitmq main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of RabbitMQ-Component"
ansible-playbook -i inventory -e component=payment main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of Payment-Component"
ansible-playbook -i inventory -e component=dispatch main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of Dispatch-Component"
ansible-playbook -i inventory -e component=web-server main.yaml &>>$LOGFILE
VALIDATE $? "Validate Installation Of Web-Component"
