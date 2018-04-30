#!/bin/bash

source ~/.ddtraining.sh

if [ ! -f /etc/haproxy/haproxy.cfg ]; then

  # Install haproxy
  sudo /usr/bin/apt-get -y install haproxy

  # Configure haproxy
  sudo bash -c 'cat > /etc/default/haproxy <<EOD
# Set ENABLED to 1 if you want the init script to start haproxy.
ENABLED=1
# Add extra flags here.
#EXTRAOPTS="-de -m 16"
EOD'
  sudo bash -c 'cat > /etc/haproxy/haproxy.cfg <<EOD
global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http-in
    bind *:80
    default_backend webservers

backend webservers
    balance roundrobin
    default-server fall 3 inter 5s
    # Poor-mans sticky
    # balance source
    # JSP SessionID Sticky
    # appsession JSESSIONID len 52 timeout 3h
    option httpchk
    option forwardfor
    option http-server-close
    server web1 172.28.33.11:80 check
    server web2 172.28.33.12:80 check
    server web3 172.28.33.13:80 check

listen stats
    bind *:8080
    mode http
    stats uri /haproxy_stats
    stats enable
EOD'

  sudo cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.orig
  sudo /usr/sbin/service haproxy restart
fi

DD_API_KEY=${DD_API_KEY} bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"

echo -n "training.hosts.started:1|c|#shell" >/dev/udp/localhost/8125

sudo mv /etc/datadog-agent/conf.d/haproxy.d/conf.yaml.example /etc/datadog-agent/conf.d/haproxy.d/conf.yaml
sudo sed -i "s/# tags: mytag, env:prod, role:database/tags:\n  - role:lb/" /etc/datadog-agent/datadog.yaml
sudo sed -i "s|  - url: http://localhost/admin?stats|  - url: http://localhost:8080/haproxy_stats|" /etc/datadog-agent/conf.d/haproxy.d/conf.yaml

printf "\nprocess_config:\n  enabled: 'true'" | sudo tee -a /etc/datadog-agent/datadog.yaml
sudo service datadog-agent restart
