#!/bin/bash

echo "🔄 Updating system packages..."
sudo yum update -y

echo "📦 Installing Ansible..."
sudo yum install ansible -y

echo "🐍 Ensuring Python3 and pip3 are installed..."
sudo yum install -y python3-pip 
python3 -m ensurepip --default-pip 
python3 -m pip install --upgrade --user pip 

echo "☁️ Installing AWS SDK dependencies (boto3 & botocore)..."
sudo python3 -m pip install boto3 botocore

echo "✅ Installation complete!"