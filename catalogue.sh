source common.sh

# set -e --- Command to to stop the script if there is any error
#set -e
echo -e "\e[35m Configuring NodeJS Repos \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

echo -e "\e[35m Install NodeJS  \e[0m"
yum install nodejs -y &>>${LOG}
status_check

echo -e "\e[35m Add Application User \e[0m"
useradd roboshop &>>${LOG}
status_check

# -p creates directory only if it doesn't exist and doesn't throw error
echo -e "\e[35m Make Directory \e[0m"
mkdir -p /app &>>${LOG}
status_check

echo -e "\e[35m Downloading App content \e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

echo -e "\e[35m  Cleanup Old Content \e[0m"
rm -rf /app/* &>>${LOG}
status_check

echo -e "\e[35mExtracting App Content  \e[0m"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
status_check

echo -e "\e[35m Installing NodeJS Dependencies \e[0m"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

echo -e "\e[35m Configuring Catalogue Service File \e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service
status_check

echo -e "\e[35m Reload SystemD \e[0m"
systemctl daemon-reload &>>${LOG}
status_check

echo -e "\e[35m Enable Catalogue Service \e[0m"
systemctl enable catalogue &>>${LOG}
status_check

echo -e "\e[35m  Start Catalogue service \e[0m"
systemctl start catalogue &>>${LOG}
status_check

echo -e "\e[35m Configuring Mongo Repo \e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

echo -e "\e[35m Install Mongo Client \e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e "\e[35m Load Schema \e[0m"
mongo --host mongodb-dev.rajdevops.online </app/schema/catalogue.js &>>${LOG}
status_check
