# @Author: atlekbai
# @Date:   2019-07-09 11:32:11
# @Last Modified by:   Tlekbai Ali
# @Last Modified time: 2019-07-09 18:42:34

if [ -z "$DBUSER" ] && [ -z "$DBPASSWORD" ]
then
	echo "set variables \$DBUSER and \$DBPASSWORD"
	exit 1
fi

wget https://github.com/alem-01/server/archive/master.zip
unzip master.zip
cd server-master

set -x

function setup-october() {
	# setup
	sudo cp -R install-master /var/www/html/$1
	sudo chown -R www-data:www-data /var/www/html/$1/
	sudo chmod -R g+rw /var/www/html/$1/
	sudo mv nginx-config/$1.nginx /etc/nginx/sites-available/
	sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/

	# install
	sudo -u postgres psql -c "CREATE DATABASE $1;"
	curl -H "Host: $1" -s localhost/api/installer | php
	php /var/www/html/$1/artisan october:install
	sudo cp cms.php /var/www/html/$1/config
	php /var/www/html/$1/artisan october:update
	
	# delete installation
	rm -rf /var/www/html/$1/install_files/
	rm /var/www/html/$1/install.php

	# setup theme
	rm -rf /var/www/html/$1/themes/demo
	unzip ~/server-master/themes/$.zip -d /var/www/html/$1/themes/demo
}

function setup-php() {
	sudo apt-get -y install software-properties-common
	sudo add-apt-repository ppa:ondrej/php
	sudo apt update
	sudo apt -y install php7.1-fpm \
						php7.1-common \
						php7.1-mbstring \
						php7.1-xmlrpc \
						php7.1-soap \
						php7.1-gd \
						php7.1-xml \
						php7.1-intl \
						php7.1-mysql \
						php7.1-cli \
						php7.1-mcrypt \
						php7.1-zip \
						php7.1-curl

	sudo mv php.ini /etc/php/7.1/fpm/php.ini
}

function setup-docker() {
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get -y install docker-ce
	sudo usermod -aG docker ${USER}
	su - ${USER}
}

function setup-docker-compose() {
	sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
}

export LC_ALL="en_US.UTF-8"

# curl
sudo apt-get -y install curl

# nginx
sudo apt -y install nginx
sudo systemctl stop nginx.service
sudo systemctl start nginx.service
sudo systemctl enable nginx.service

# postgres
sudo apt-get update
sudo apt-get -y install postgresql postgresql-contrib
sudo -u postgres psql -c "CREATE USER $DBUSER WITH PASSWORD '$DBPASSWORD';"
sudo -u postgres psql -c "ALTER USER $DBUSER WITH SUPERUSER;"

# php 7
setup-php

# OctoberCMS
cd /tmp
wget http://octobercms.com/download -O octobercms.zip
sudo unzip octobercms.zip

# alem.school
setup-october alem.school

# umit.fund
setup-october umit.fund

rm -rf install-master
rm cms.php

# restart nginx
sudo systemctl restart nginx.service

# docker
# setup-docker && setup-docker-compose
