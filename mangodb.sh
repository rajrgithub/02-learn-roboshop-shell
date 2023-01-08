source common.sh

print_head "Copy MongoDB Repo file"
cp ${script_location}/files/mangodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "Install MongoDB"
yum install mongodb-org -y &>>${LOG}
status_check

print_head "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

print_head "Enable  MongoDB to start at boot time"
systemctl enable mongod &>>${LOG}
status_check

print_head "Restart MongoDB"
systemctl restart mongod &>>${LOG}
status_check

