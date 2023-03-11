#!/bin/bash -x
## Setup http://labs.play-with-k8s.com/
#
# Inspired heavily by: https://gist.github.com/jjo/78f60702fbfa1cbec7dd865f67a3728a
# Some dev-tools omitted, changes in parenthesis.
#
# Run with:
# bash -x <( curl -L url-to-raw-gist )
#

# Initialize cluster and FIXUP some play-with-k8s annoyances (fixed kube-dashboard shortlink, update port-number)
test -d /etc/kubernetes/pki || (
# run kubeadm
kubeadm init --apiserver-advertise-address $(hostname -i) | tee ~/kubeadm-init.log
# apply weave cni
kubectl apply -n kube-system -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 -w0)"
# apply dashboard
curl -L -s https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml | sed 's/targetPort: 8443/targetPort: 8443\n  type: LoadBalancer/' | kubectl apply -f -
# add Google's 8.8.8.8 dns
kubectl get deployment --namespace=kube-system kube-dns -oyaml|sed -r 's,(.*--server)=(/ip6.arpa/.*),&\n\1=8.8.8.8,'|kubectl apply -f -
# add service account to dashboard, from https://gist.github.com/figaw/17dc8ed72c8d2fe1a12682beb9c1e57e
# this gives anyone with access to the dashboard the cluster-admin role.. so.. clearly this is for development.
kubectl create -f https://gist.githubusercontent.com/figaw/17dc8ed72c8d2fe1a12682beb9c1e57e/raw/e2c472cab2aa2ffb410999bcdbd158aa7617d9a3/service-account.yaml
)

# k8s comfy'ness (add emacs)
cd
yum -q -y install bash-completion git-core tmux vim emacs wget sudo which > /dev/null
kubectl completion bash > /etc/bash_completion.d/kubectl.completion
source /etc/bash_completion.d/kubectl.completion

# show kubeadm join ...
echo "* Join nodes with:"
grep -A 1 'kubeadm join' kubeadm-init.log
# (master shouldn't join
# kubeadm join --token $(kubeadm token list |sed -n 2p|egrep -o '^\S+') $(sed -rn s,.*server:.*//,,p /etc/kubernetes/admin.conf)