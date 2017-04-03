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
sudo add-apt-repository ppa:ondrej/php5-5.6
sudo apt-get -y install python-software-properties
sudo apt-get -y install software-properties-common
sudo apt-get -y update

# Apache, Php, MySQL and required packages installation

# Basic Requirements
sudo apt-get -y install pwgen python-setuptools curl git nano sudo unzip openssh-server openssl


# Magento Requirements
sudo apt-get -y install apache2 libcurl3 php5 php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-imagick php5-intl php5-xsl mysql-client-5.6 mysql-client-core-5.6

sudo a2enmod rewrite
sudo php5enmod mcrypt
sudo a2enmod ssl

# Set apache permission
sudo gpasswd -a "$USER" www-data

sudo sed -i -e"s/user\s*=\s*www-data/user = $USER www-data/" /etc/php5/fpm/pool.d/www.conf
sudo sed -i -e"s/listen.owner\s*=\s*www-data/listen.owner = $USER www-data/" /etc/php5/fpm/pool.d/www.conf

# Install Mod-FastCGI and PHP5-FPM on Ubuntu 14.04
sudo apt-get -y install apache2-mpm-worker libapache2-mod-fastcgi php5-fpm
sudo a2enmod actions alias fastcgi


#The following commands set the MySQL root password to 'mypassword' when you install the mysql-server package.

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password mypassword'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mypassword'
sudo apt-get -y install mysql-server-5.6

# mysql config on Ubuntu 14.04
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