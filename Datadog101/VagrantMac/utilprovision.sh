#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

source ~/.ddtraining.sh

DD_API_KEY=${DD_API_KEY} bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"

sudo sed -i "s/# tags:/tags:\n  - role:util/" /etc/datadog-agent/datadog.yaml
printf "\nprocess_config:\n  enabled: 'true'" | sudo tee -a /etc/datadog-agent/datadog.yaml

sudo service datadog-agent restart
source /home/vagrant/.nvm/nvm.sh
nvm install node
npm i autocannon -g

printf "#! /bin/sh\nps -ef | grep autocannon | grep -v grep\n[ $?  -eq '0' ] && pkill -f autocannon || echo 'process is not running'\nautocannon -f -d 10 -c 2 -r 1 172.28.33.10" >> light
printf "#! /bin/sh\nps -ef | grep autocannon | grep -v grep\n[ $?  -eq '0' ] && pkill -f autocannon || echo 'process is not running'\nautocannon -f -d 10 -c 100 -r 100 172.28.33.10" >> heavy
sudo chmod +x light heavy
sudo mv light /usr/local/bin
sudo mv heavy /usr/local/bin

