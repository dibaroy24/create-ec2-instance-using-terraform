#!/bin/bash

# Update package repositories
sudo apt-get update -y

# Install nginx
sudo apt-get install nginx -y

# Start nginx service
sudo systemctl start nginx

# Enable nginx to start on boot
sudo systemctl enable nginx
