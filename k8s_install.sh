docker_Version="docker-ce=18.06.1~ce~3-0~ubuntu"
k8s_version="1.12.7-00"
pod_network_cidr="10.244.0.0/16"


install_docker()
{
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install -y ${docker_Version}
sudo apt-mark hold docker-ce
sudo systemctl status docker
}

install_k8s()
{
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet=${k8s_version} kubeadm=${k8s_version} kubectl=${k8s_version}
sudo apt-mark hold kubelet kubeadm kubectl
}

bootstrap_k8s()
{
sudo kubeadm init --pod-network-cidr=${pod_network_cidr}
}

setup_kubeconfig()
{
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
}


k8s_join()
{
kubeadm join 10.0.1.101:6443 --token bjt690.zatbwk68sx22ggpk --discovery-token-ca-cert-hash sha256:7e65aa46868f9adea1a26851d8326778139b4b8da87930096a8783bc5ce22cb2
}


install_docker
install_k8s
bootstrap_k8s
