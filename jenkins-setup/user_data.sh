#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

echo "Starting system update..."
apt-get update -y
apt-get upgrade -y

echo "Installing OpenJDK 17..."
apt-get install -y openjdk-17-jdk

echo "Adding Jenkins repo and installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list
apt-get update -y
apt-get install -y jenkins
systemctl daemon-reload
systemctl start jenkins
systemctl enable jenkins

echo "Installing prerequisites for Docker..."
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2

echo "Adding Docker GPG key and repo..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu focal stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
echo "Installing Docker CE..."
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Adding 'ubuntu' and 'jenkins' users to docker group..."
usermod -aG docker ubuntu
usermod -aG docker jenkins

systemctl start docker
systemctl enable docker

echo "Installing kubectl v1.30.0..."
KUBECTL_VERSION="v1.30.0"
for i in {1..5}; do
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && break || sleep 5
done
chmod +x kubectl
mv kubectl /usr/local/bin/
kubectl version --client

echo "Installing Helm..."
for i in {1..5}; do
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && break || sleep 5
done
chmod 700 get_helm.sh
./get_helm.sh
helm version
rm -f get_helm.sh

if [ -d /home/ubuntu/.kube ]; then
    chown -R ubuntu:ubuntu /home/ubuntu/.kube
fi

echo "Installing AWS CLI..."
apt-get install -y unzip
curl -fsSL -o awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

echo "Fixing permissions for Jenkins directories..."
chown -R jenkins:jenkins /var/lib/jenkins
chown -R jenkins:jenkins /var/cache/jenkins
chown -R jenkins:jenkins /var/log/jenkins
chown -R ubuntu:ubuntu /home/ubuntu/.kube

echo "Jenkins, Docker, Helm, kubectl, and AWS CLI installation completed successfully!"
