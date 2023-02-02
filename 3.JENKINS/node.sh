
# # install kubectl
# cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
# [kubernetes]
# name=Kubernetes
# baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
# enabled=1
# gpgcheck=1
# gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
# EOF
# sudo yum install -y kubectl

# # installing docker
# curl -s https://get.docker.com/ | bash
# sudo systemctl start docker
# usermod -a -G docker centos

# # installing helm
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh


# # install k9's
# sudo yum install snapd -y
# sudo systemctl enable --now snapd.socket
# sudo ln -s /var/lib/snapd/snap /snap

# # bash completion
# sudo yum install -y bash-completion
# echo "source <(kubectl completion bash)" >> ~/.bashrc