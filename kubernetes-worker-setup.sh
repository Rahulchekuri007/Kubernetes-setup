#!/bin/bash

# Deploy Kubernetes Worker Setup.
name=$(hostname -f)
set -e

kube_version="1.9.2-00"
kube_release="stable-1.9"
kube_cni="weavenet"
workers_count=1
ubuntu_release=xenial
master_nodes="edalkbmp01.elan.elantecs.com"

###########################################################################################

#Install Basic Packages
apt-get update -y
apt-get install -y lsof curl

###########################################################################################

#AWS CLI Setup

apt-get install -y ruby curl python

curl -O https://bootstrap.pypa.io/get-pip.py

python get-pip.py

pip install awscli

#############################################################################################

#Setup and Install Kubernetes repos and packages

sudo echo "deb http://security.ubuntu.com/ubuntu/ ${ubuntu_release}-updates universe" > /etc/apt/sources.list.d/docker.list
apt-get install apt-transport-https
apt-get update
apt-get install -y docker.io

cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
EOF

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-${ubuntu_release} main
EOF

apt-get update
if [ ${kube_version} = latest ];then
apt-get install -y kubectl kubelet kubeadm
else
apt-get install -y kubectl=${kube_version} kubelet=${kube_version} kubeadm=${kube_version}
fi

swapoff -a
sed -i "/swap/ s/^/#/g" /etc/fstab

# Install nfs-common for Kubernetes Storage
apt-get install -y nfs-common
##############################################################################################
ln -s /home/awsadmin/.aws /root/.aws
aws s3 cp s3://elanrepo/files/kubernetes/local/authorized_keys /root/.ssh/aws_authorized_keys
cat /root/.ssh/aws_authorized_keys >> /root/.ssh/authorized_keys
unlink /root/.aws
###############################################################################################
