#!/bin/bash
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install nodejs -y 

yum install git -y 
git clone https://github.com/ChaitanyaChandra/DevOps.git
cd DevOps\0.APPLICATIONS\spec\
npm  install
node index.js & 