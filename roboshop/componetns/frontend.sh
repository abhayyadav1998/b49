#!/bin/bash
source ./componentns/common.sh
set -e
COMPONENT=frontend
LOGFILE=/tmp/$COMPONENT.log

echo -n "Installing Nginx"
yum install nginx -y &>> $LOGFILE
stat $?

echo -n "enable nginx"
systemctl enable nginx &>> $LOGFILE
stat $?

echo -n "start nginx"
systemctl start nginx &>> $LOGFILE
stat $?

echo -n "Downloading $COMPONENT"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
cd /usr/share/nginx/html

echo -n "cleaning old content"
rm -rf *
stat $?

unzip /tmp/frontend.zip &>> $LOGFILE
stat $?

mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md

echo -n "configure proxy"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "____________________ \e[32m $COMPONENT congiguration is completed _________\e[0m"
