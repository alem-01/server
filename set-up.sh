# @Author: atlekbai
# @Date:   2019-07-09 11:32:11
# @Last Modified by:   atlekbai
# @Last Modified time: 2019-07-09 15:10:18

export LC_ALL="en_US.UTF-8"

# nginx
sudo apt -y install nginx
sudo systemctl stop nginx.service
sudo systemctl start nginx.service
sudo systemctl enable nginx.service

# postgres
sudo apt-get update
sudo apt-get -y install postgresql postgresql-contrib

# php 7
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

sudo cp php.ini /etc/php/7.1/fpm/php.ini

# OctoberCMS
cd /tmp && wget http://octobercms.com/download -O octobercms.zip
sudo unzip octobercms.zip

# alem.school
sudo cp -R install-master /var/www/html/alem.school
sudo chown -R www-data:www-data /var/www/html/alem.school/
sudo chmod -R g+rw /var/www/html/alem.school/
sudo mv alem.school.nginx /etc/nginx/sites-available/alem.school
sudo ln -s /etc/nginx/sites-available/alem.school /etc/nginx/sites-enabled/

# umit.fund
sudo cp -R install-master /var/www/html/umit.fund
sudo chown -R www-data:www-data /var/www/html/umit.fund/
sudo chmod -R g+rw /var/www/html/umit.fund/
sudo mv umit.fund.nginx /etc/nginx/sites-available/umit.fund
sudo ln -s /etc/nginx/sites-available/umit.fund /etc/nginx/sites-enabled/

rm -rf install-master

# restart nginx
sudo systemctl restart nginx.service

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker ${USER}
su - ${USER}
