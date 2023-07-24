echo ">>>>>> Create catalogue service <<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service

echo ">>>>>> Create MongoDB Repo <<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo ">>>>>> Install NodeJS Repos <<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo ">>>>>> Install NodeJS <<<<<<"
yum install nodejs -y

echo ">>>>>> Create Application User <<<<<<"
useradd roboshop

echo ">>>>>> Create Application Directory <<<<<<"
mkdir /app

echo ">>>>>> Download Application Content <<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo ">>>>>> Extract Application Content <<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo ">>>>>> Downlaod NodeJS Dependencies<<<<<<<"
npm install

echo ">>>>>> Install Mongo Client <<<<<<"
yum install mongodb-org-shell -y

echo ">>>>>> Load Catalogue Schema <<<<<<"
mongo --host mongodb.manasareddy.online </app/schema/catalogue.js

echo ">>>>>> Start System Service <<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue