component=payment
source common.sh
rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo Input RabbitMQ App user password Missing
  exit 1
  fi
func_python


