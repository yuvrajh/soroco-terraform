#!/bin/bash
sudo mv /var/tmp/aws-mon /var/tmp/aws-mon.bak
sudo echo "* * * * * /opt/scripts/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-avail --mem-used  --memory-units=megabytes --auto-scaling=only" >> /etc/crontab
sudo mv /var/tmp/aws-mon /var/tmp/aws-mon.bak
