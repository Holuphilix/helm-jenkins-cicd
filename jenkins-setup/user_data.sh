#!/bin/bash

# Update package lists
sudo apt update -y

# Install OpenJDK 17 (required by Jenkins)
sudo apt install -y openjdk-17-jdk

# Verify Java version
java -version

# Add Jenkins key and repository
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update packages and install Jenkins, Git, Curl, etc.
sudo apt update -y
sudo apt install -y jenkins git unzip curl

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Configure firewall to allow Jenkins (port 8080) and SSH (port 22)
sudo ufw allow 8080
sudo ufw allow OpenSSH
sudo ufw --force enable

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Add Jenkins and current user to docker group
sudo usermod -aG docker jenkins
sudo usermod -aG docker $USER

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
