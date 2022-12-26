#!/bin/bash

# install nodejs
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install nodejs -y 

# install git
sudo yum install git -y 
git clone https://github.com/ChaitanyaChandra/DevOps.git

# run nodejs application
cd DevOps\0.APPLICATIONS\spec\
sudo npm  install
sudo node index.js & 

# install nginx 
sudo yum install epel-release
sudo yum install nginx -y 
curl -sL https://raw.githubusercontent.com/ChaitanyaChandra/DevOps/main/0.APPLICATIONS/run.sh 

# run the script 
# curl -sL https://raw.githubusercontent.com/ChaitanyaChandra/DevOps/main/0.APPLICATIONS/run.sh | sudo bash - 