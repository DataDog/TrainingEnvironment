#!/bin/bash

source ~/.ddtraining.sh

export DEBIAN_FRONTEND=noninteractive

sudo add-apt-repository ppa:ondrej/php
sudo apt-get update

sudo apt-get install -q -y -f apache2 php7.0 libapache2-mod-php7.0 php7.0-cli php7.0-common php7.0-mbstring php7.0-gd php7.0-intl php7.0-xml php7.0-mcrypt php7.0-zip curl
sudo mv /var/www/html/index.html /var/www/html/index.html.bak

sudo sed -i "s/vagrant/$1/" /etc/hostname
sudo sed -i "s/vagrant/$1/g" /etc/hosts
hostname $1
printf "<div id=maintitle >You have connected to server <strong>\n<?php
echo gethostname();\n?></strong></div>\n<br>" >> /var/www/html/index.php

printf "\nExtendedStatus ON" >> /etc/apache2/apache2.conf
printf "\n<Location /server-status>\n\tSetHandler server-status\n\tRequire all granted\n</Location>\n" >> /etc/apache2/apache2.conf
sudo systemctl restart apache2.service


DD_API_KEY=${DD_API_KEY} bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"



sudo mv /etc/datadog-agent/conf.d/apache.d/conf.yaml.example /etc/datadog-agent/conf.d/apache.d/conf.yaml
sudo sed -i "s/# tags:/tags:\n  - role:web/" /etc/datadog-agent/datadog.yaml
printf "\nprocess_config:\n  enabled: 'true'" | sudo tee -a /etc/datadog-agent/datadog.yaml

sudo service datadog-agent restart