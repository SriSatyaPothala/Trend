#!/bin/bash

#update system packages
sudo apt-get update -y
sudo apt-get upgrade -y 

# install java 
sudo apt-get install -y openjdk-21-jdk

# add jenkins repo and key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

#install jenkins

sudo apt-get update -y
sudo apt-get install -y jenkins

# install docker

sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Add Docker's GPG key

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#Set up docker repo

echo \ 
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker engine

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# start and enable docker and jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl enable docker
sudo systemctl start docker

# add jenkins user to docker group 
sudo usermod -aG docker jenkins

