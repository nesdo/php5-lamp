#!/bin/bash

# Instructions to use this script
#
#   $ chmod +x php5-lamp-setup.sh
#
#   $ sudo ./php5-lamp-setup.sh
#
# Tested on Ubuntu 14.04 LTS
# PHP 5.6
# MySQL 5.6
# Apache 2


echo "###################################################################################"
echo "Please be Patient: Installation will start now.......and it will take some time :)"
echo "###################################################################################"

# Update the repositories
#sudo add-apt-repository ppa:ondrej/php5-5.6
sudo apt-get -y install python-software-properties
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get -y update
sudo apt-get -y upgrade

# Apache, Php, MySQL and required packages installation

# Basic Requirements
sudo apt-get -y install pwgen python-setuptools curl git nano sudo unzip openssh-server openssl
sudo curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
sudo curl -sSL https://raw.github.com/colinmollenhour/modman/master/modman > /usr/local/bin/modman
sudo chmod +x /usr/local/bin/modman

# Magento Requirements
sudo apt-get -y install apache2 libcurl3 php5.6 php5.6-common php5.6-mcrypt php5.6-curl php5.6-cli php5.6-mysql php5.6-gd php5-imagick php5.6-intl php5.6-xsl mysql-client-5.6 mysql-client-core-5.6 php5.6-dom php5.6-soap php5.6-mbstring


sudo a2enmod rewrite
sudo a2enmod ssl
sudo php5enmod mcrypt
sudo php5enmod php5


# Set apache permission
sudo gpasswd -a "$USER" www-data

sudo sed -i -e"s/user\s*=\s*www-data/user = $USER /" /etc/php5/fpm/pool.d/www.conf
sudo sed -i -e"s/listen.owner\s*=\s*www-data/listen.owner = $USER /" /etc/php5/fpm/pool.d/www.conf

# Install Mod-FastCGI and PHP5-FPM on Ubuntu 14.04
sudo apt-get -y install apache2-mpm-worker libapache2-mod-fastcgi php5.6-fpm
sudo a2enmod actions alias fastcgi


#The following commands set the MySQL root password to 'mypassword' when you install the mysql-server package.

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password mypassword'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mypassword'
sudo apt-get -y install mysql-server-5.6

# mysql config on Ubuntu 14.04 to be remote server
sudo sed -i -e"s/^bind-address\s*=\s*127.0.0.1/explicit_defaults_for_timestamp = true\n#bind-address = 0.0.0.0/" /etc/mysql/my.cnf
mysql -uroot -p'mypassword' -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'mypassword' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Install phpmyadmin
#echo -e "\n Installing phpMyAdmin"
#sudo apt-get -y install phpmyadmin

#Restart all the installed services to verify that everything is installed properly

echo -e "\n"

service apache2 restart && service mysql restart > /dev/null

echo -e "\n"

if [ $? -ne 0 ]; then
   echo "Please Check the Install Services, There is some $(tput bold)$(tput setaf 1)Problem$(tput sgr0)"
else
   echo "Installed Services run $(tput bold)$(tput setaf 2)Sucessfully$(tput sgr0)"
fi

echo -e "\n"