#!/bin/bash

# Start the proxy
echo 'Starting the nginx reverse proxy'
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy

# Start the Laravel containers
echo 'Starting the Laravel containers'
docker-compose up -d

# Set the hosts file
echo 'Setting the hosts file'
VIRTUAL_HOST_TMP=$(grep 'VIRTUAL_HOST=' docker-compose.yml | tail -n1 | awk '{ print $2}')
VIRTUAL_HOST=${VIRTUAL_HOST_TMP/VIRTUAL_HOST=/}
IP_ADDRESS=$(docker-machine ip)

if grep -q "$IP_ADDRESS $VIRTUAL_HOST" /etc/hosts; then
    echo "Virtual Host already in hosts file"
else
    echo $IP_ADDRESS $VIRTUAL_HOST | sudo tee -a /etc/hosts
fi
