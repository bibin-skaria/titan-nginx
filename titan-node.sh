#!/bin/bash
#if already exit and want to delete and want to make new
docker stop angular-node angular-nginx haproxy-node
#if already exit and want to delete and want to make new 
docker rm angular-node angular-nginx haproxy-node

#if existed then ignore , it is only for new server config
#docker network create docker-network

#build a angular-nginx
docker build --tag angular-nginx .

# run angular-nginx for port 80 
#***** please check default.conf file in current folder before executing
docker run -d --name angular-nginx -p 8081:80 --net docker-network --restart unless-stopped -v /opt/angular/www/html:/var/www/html angular-nginx:latest

# run angular-node for port 3003
docker run -d --name angular-node --cpus=".5" -p 3003:3003 --net docker-network --restart unless-stopped -v /opt/angular/www/html:/var/www/html bibin9992009/angular-node-v2:latest

#if already have then comment 
mkdir /home/ubuntu/haproxy

#jump to haproxy file
cd /home/ubuntu/haproxy

#copy current haproxy config file
cp /home/ubuntu/gateway_docker_follower_node1/titan-nginx/haproxy.cfg .

#use this command maunally if needed , before run it manually change directory into /home/ubuntu/haproxy or wherever you kept haproxy.cfg
# search and replace both command to find docker container internall ip and paste into our haproxy file
#sed -i "s/172.18.0.1/$var/g" haproxy.cfg | var=$(echo $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' angular-node)) 

#sed -i "s/172.18.0.2/$var/g" haproxy.cfg | var=$(echo $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' angular-nginx))

docker run -d -p 80:80 -p 1936:1936 --name haproxy-node --net docker-network --restart unless-stopped -v /home/ubuntu/haproxy:/usr/local/etc/haproxy:ro haproxy
