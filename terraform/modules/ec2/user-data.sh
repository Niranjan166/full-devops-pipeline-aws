#!/bin/bash

apt-get update -y

apt-get install -y docker.io

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

apt-get install -y awscli git curl unzip