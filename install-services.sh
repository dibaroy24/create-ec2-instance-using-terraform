#!/bin/bash
# Update package repositories
sudo yum update -y

# Install docker
sudo yum install docker -y

# Start the docker service
sudo service docker start

# Enable Docker commands without sudo (optional but recommended)
sudo usermod -a -G docker ec2-user

# Install nginx
sudo yum install nginx -y

# Start nginx service
sudo systemctl start nginx

# Enable nginx to start on boot
sudo systemctl enable nginx
