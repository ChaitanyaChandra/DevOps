#!/bin/bash

LOG=/opt/user-data-$$.log
ansible-pull -i localhost -U https://github.com/ChaitanyaChandra/DevOps.git 2.ANSIBLE/spec.yml -e 'ROLE=${COMPONENT_ROLE}' -e 'HOST=localhost' -e 'ROOT_USER=true' -e 'APP_VERSION=${APP_VERSION}' -e 'ENV=${ENV}' ${ROLE_AUGMENTS} -c 2.ANSIBLE/ansible.cfg -d /tmp/ansible &>>$LOG