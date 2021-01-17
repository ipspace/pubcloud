#! /bin/bash

#install apache
sudo apt-get --assume-yes update
sudo apt-get --assume-yes upgrade

# Apply FW rules to accept connections on 22
sudo ufw allow 22/tcp
sudo ufw --force enable 
