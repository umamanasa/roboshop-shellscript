func_apppreq(){
  echo -e "\e[36m>>>>>> Create Application User <<<<<\e[0m"
    useradd roboshop &>>${log}

    echo -e "\e[36m>>>>>> Removing Previous Content <<<<<\e[0m"
    rm -rf /app &>>${log}

    echo -e "\e[36m>>>>>> Create Application Directory <<<<<\e[0m"
    mkdir /app &>>${log}

    echo -e "\e[36m>>>>>> Download Application Content <<<<<\e[0m"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

    echo -e "\e[36m>>>>>> Extract Application Content <<<<<\e[0m"
    cd /app
    unzip /tmp/${component}.zip &>>${log}
    cd /app

}

func_systemd(){
  echo -e "\e[36m>>>>>> Start ${component} Service <<<<<\e[0m"
    systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl restart ${component} &>>${log}
}
func_nodejs(){
  log=/tmp/roboshop.log
  echo -e "\e[36m>>>>>> Create ${component} service <<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[36m>>>>>> Create MongoDB Repo <<<<<\e[0m"

  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e "\e[36m>>>>>> Install NodeJS Repos <<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  echo -e "\e[36m>>>>>> Install NodeJS <<<<<\e[0m"
  yum install nodejs -y &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>> Downlaod NodeJS Dependencies<<<<<<\e[0m"
  npm install &>>${log}

  echo -e "\e[36m>>>>>> Install Mongo Client <<<<<\e[0m"
  yum install mongodb-org-shell -y &>>${log}

  echo -e "\e[36m>>>>>> Load ${component} Schema <<<<<\e[0m"
  mongo --host mongodb.manasareddy.online </app/schema/${component}.js &>>${log}

  func_systemd

}

func_java(){
  echo -e "\e[36m>>>>>> Create ${component} service <<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[36m>>>>>> install maven <<<<<\e[0m"
  yum install maven -y

  func_apppreq

  echo -e "\e[36m>>>>>> Build ${component} service <<<<<\e[0m"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar


  echo -e "\e[36m>>>>>> Install MYSQL Client <<<<<\e[0m"
  yum install mysql -y

  echo -e "\e[36m>>>>>> Load Schema <<<<<\e[0m"
  mysql -h mysql.manasareddy.online -uroot -pRoboShop@1 < /app/schema/${component}.sql

  func_systemd

}