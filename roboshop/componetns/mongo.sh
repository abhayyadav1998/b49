#!/bin/bash
source ./componentns/common.sh
set -e
COMPONENT=frontend
LOGFILE=/tmp/$COMPONENT.log
MONGO_REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"
MONGO_SCEMA="https://github.com/stans-robot-project/mongodb/archive/main.zip"

echo -n "Downloading $COMPONENT"
curl -s -o /etc/yum.repos.d/mongodb.repo $MONGO_REPO_URL
stat $?
echo -n "Installing $COMPONENT"
yum install -y mongodb-org & >> $LOGFILE
stat $?

systemctl enable mongod & >> $LOGFILE
stat $?

echo -n "starting $COMPONENT"
systemctl start mongod & >> $LOGFILE

stat $?
echo -n "Updating listing address for  $COMPONENT"

sed -i -e /s/127.0.0.1/0.0.0.0/ etc/mongod.conf

systemctl restart mongod & >> $LOGFILE

stat $?
echo -n "Downloading mongo scema"
curl -s -L -o /tmp/mongodb.zip "$MONGO_SCEMA"
cd /tmp
stat $?
echo -n "unzip mongo scema"
unzip mongodb.zip
cd mongodb-main

stat $?
echo -n "insert mongo scema"
mongo < catalogue.js & >> $LOGFILE
mongo < users.js & >> $LOGFILE

stat $?
echo -n  "___________ Setup of Mongo is Successfully Done_________"
