#!/bin/bash

#install apache
sudo apt-get -f autoremove
sudo apt-get --asume-yes update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes dist-upgrade
sudo apt-get --assume-yes install apache2

# Apply FW rules to accept connections on 22, 80 and 443
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw --force enable 

# enable apache modules and XbitHack for SSI
sudo a2enmod include cgi
cd /var/www/html
sudo rm index.html
sudo wget -O index.html https://raw.githubusercontent.com/MihaMarkocic/cloudservices/master/AWS/web_application_firewall/init_files/index.html
sudo bash -c "sed -i 's/SERVER_NAME/$1/' index.html"
sudo wget https://raw.githubusercontent.com/MihaMarkocic/cloudservices/master/AWS/web_application_firewall/init_files/.htaccess
echo 'XbitHack on' >> /etc/apache2/apache2.conf
sudo bash -c "sed -i 's/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks Includes/' /etc/apache2/apache2.conf"
sudo chmod +x /var/www/html/index.html

# install net-tools to do ifconfig SSI on frontpage
sudo apt install net-tools

#restart apache2 service
sudo systemctl restart apache2