# Kubernetes-setup
k8s setup
Setup Kub8s Basic Cluster:
**Disable Swap memory 
#swapoff -a
#vi /etc/fstab
comment the swap partition
**Disable the selinux but setting it in permissive
**Make sure the firewall is down and certain ports are open for kub8s
**Add the docker repo if not installed
[dockerrepo]
name=docker repo
baseurl=http://yum.dockerproject.org/repo/main/centos/7/
gpgcheck=1
enabled=1
gpgkey=https://yum.dockerproject.org/gpg

#yum install -y docker-engine
#systemctl enable docker
#systemctl start docker 
#cd /var/run
#usermod username -G docker
#logout 
login and use basic command
#docker images -->with normal user need to have access
**Now add the kub8s repo 
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

#yum update
#yum install -y kubelet kubeadm kubectl
#systemctl enable kubelet.service
#systemctl start kubelet.service
#cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
#sysctl --system
#kubeadm init --pod-network-cidr=10.244.0.0/16
follow the instructions at the end of execution
and save the join token to use it in the cluster nodes
till here everything is done as root user and exit at this point 
**now as regular user
**#mkdir -p $HOME/.kube
**#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
**#sudo chown $(id -u):$(id -g) $HOME/.kube/config
*#kubectl get nodes
**once the master is up
**kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
**The above line is to install the flannel type cni

**To setup the cluster node we need to follow till the start up of kubelet service #system --system.
**#kubeadm join 172.31.36.23:6443 --token vj8vem.hhdp4pcqncpxo3wq --discovery-token-ca-cert-hash sha256:71fde630a5f35945f80650dd81c44a7f3f217b649f492399f89688a8b07d5d24


