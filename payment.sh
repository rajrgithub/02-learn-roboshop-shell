source common.sh

component=payment
schema_load=false

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "Variable roboshop_rabbitmq_password is missing"
  exit 1
fi

PYTHON


# export roboshop_rabbitmq_password=roboshop123
# sudo -E bash payment.sh