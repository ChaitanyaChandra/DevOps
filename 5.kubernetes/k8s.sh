#!/bin/bash -x

kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16 | tee ~/kubeadm-init.log
kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml

# k8s comfy'ness (add emacs)
cd
yum -q -y install bash-completion git-core tmux vim emacs wget sudo which > /dev/null
kubectl completion bash > /etc/bash_completion.d/kubectl.completion
source /etc/bash_completion.d/kubectl.completion

# show kubeadm join ...
echo "* Join nodes with:"
grep -A 1 'kubeadm join' kubeadm-init.log