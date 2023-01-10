ansible-playbook spec.yml  -e 'ROLE=datadog'
 ansible-playbook spec.yml  -e 'ROLE=frontend' -e 'proxy_host=localhost'