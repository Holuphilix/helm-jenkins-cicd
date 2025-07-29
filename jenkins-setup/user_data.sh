#!/bin/bash
# Redirect output to a log file for debugging
exec > /var/log/user-data.log 2>&1

# Update the system
apt-get update -y
apt-get upgrade -y

# Install OpenJDK 17 for Jenkins
apt-get install -y openjdk-17-jdk

# Install Jenkins
wget -q -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list
apt-get update -y
if ! apt-get install -y jenkins; then
  echo "Jenkins installation failed" >&2
  exit 1
fi
systemctl start jenkins
systemctl enable jenkins

# Install Docker
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-get update -y
if ! apt-get install -y docker-ce; then
  echo "Docker installation failed" >&2
  exit 1
fi
usermod -aG docker ubuntu
systemctl start docker
systemctl enable docker

# Install kubectl (use a specific version for reliability)
KUBECTL_VERSION="v1.30.0"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
if [ $? -ne 0 ]; then
  echo "kubectl download failed" >&2
  exit 1
fi
chmod +x kubectl
mv kubectl /usr/local/bin/
kubectl version --client

# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
if [ $? -ne 0 ]; then
  echo "Helm download failed" >&2
  exit 1
fi
chmod 700 get_helm.sh
./get_helm.sh
helm version

if [ -d /home/ubuntu/.kube ]; then
  chown -R ubuntu:ubuntu /home/ubuntu/.kube
fi

# Install AWS CLI
echo "Installing AWS CLI..."
curl -fsSL -o awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
sudo apt-get install -y unzip
unzip awscliv2.zip
sudo ./aws/install
rm -f awscliv2.zip
rm -rf aws

# Ensure permissions
chown -R jenkins:jenkins /var/lib/jenkins
chown -R jenkins:jenkins /var/cache/jenkins
chown -R jenkins:jenkins /var/log/jenkins
chown -R ubuntu:ubuntu /home/ubuntu/.kube

echo " Jenkins + Docker + Helm + kubectl + AWS CLI are ready!"