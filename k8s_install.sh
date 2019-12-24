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
