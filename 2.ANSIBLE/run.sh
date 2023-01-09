ansible-galaxy collection install -r requirements.yml
ansible-playbook spec.yml -e 'ansible_python_interpreter=/usr/bin/python3' -e 'ROLE=datadog'