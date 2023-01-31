#!/bin/bash
yum install java-11-openjdk -y

yum install unzip -y

yum install zip -y

yum install wget -y

# install jq
yum install epel-release -y
yum install jq -y

# install sonar scannar
cd /opt
curl -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.5.0.2216-linux.zip
unzip sonar-scanner-cli-4.5.0.2216-linux.zip
rm -rf sonar
mv sonar-scanner-4.5.0.2216-linux sonar
ln -s /opt/sonar/bin/sonar-scanner /bin/sonar-scanner
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/sonar-scanner/sonar-quality-gate >/bin/sonar-quality-gate.sh
chmod +x /bin/sonar-quality-gate.sh

# install nodejs
yum install gcc-c++ -y

URL=$(curl -s https://nodejs.org/en/download/ | xargs -n1 | grep linux-x64.tar | sed -e 's|=| |g' -e 's|>| |g'| xargs -n1 | grep ^http)
FILENAME=$(echo $URL | awk -F / '{print $NF}')
FOLDER_NAME=$(echo $FILENAME |sed -e 's/.tar.xz//')

curl -s -o /tmp/$FILENAME $URL
cd /opt
tar -xf /tmp/$FILENAME
mv $FOLDER_NAME nodejs
ln -s /opt/nodejs/bin/node /bin/node || true
ln -s /opt/nodejs/bin/npm /bin/npm  || true
ln -s /opt/nodejs/bin/npx /bin/npx || true

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# install aws cli

sudo python -m pip install awscli --ignore-installed six

# istall .net for azure devops
sudo su -c 'curl https://download.mono-project.com/repo/centos7-stable.repo | tee /etc/yum.repos.d/mono-centos7-stable.repo'
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
sudo yum install -y libgdiplus
sudo yum install -y dotnet-runtime-3.1

# install kubectl
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubectl

# installing docker
curl -s https://get.docker.com/ | bash
sudo systemctl start docker
usermod -a -G docker centos

# installing helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


# install k9's
sudo yum install snapd -y
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# bash completion
sudo yum install -y bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc