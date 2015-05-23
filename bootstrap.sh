#!/bin/bash

# Install packages
apt-get update
apt-get -y install npm make nginx gzip git-core python libssl-dev pkg-config build-essential tmux
# Not available from repo: php-fpm docuwiki

wget http://node-arm.herokuapp.com/node_latest_armhf.deb
dpkg -i node_latest_armhf.deb

# Set up nginx
mkdir -p /var/www/vhosts/pi-collab/httpdocs
cp pi-collab.conf /etc/nginx/conf.d/
cp user_agent_block /etc/nginx/

# Create etherpad user
useradd -m etherpad
echo -e '\nexport PATH=$PATH:/usr/local/bin' >> /home/etherpad/.bashrc

su etherpad -c 'git clone http://github.com/ether/etherpad-lite.git /home/etherpad/etherpad-lite'

cd /home/etherpad/etherpad-lite
su etherpad -c 'sh bin/run.sh'
