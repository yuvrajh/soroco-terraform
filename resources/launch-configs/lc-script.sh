#!/bin/bash
apt-get update -y
sudo apt-get install python3 -y
sudo apt install python-pip -y
sudo pip install --upgrade pip
sudo pip install awscli --upgrade
sudo aws s3 cp s3://ap-south-1-soroco-rds-postgresql-logs-bucket/rds-logs-to-s3.sh /opt/  --region ap-south-1
sudo chmod +x /opt/rds-logs-to-s3.sh
sudo echo "*/10 * * * * root sh /opt/rds-logs-to-s3.sh" >> /etc/crontab
