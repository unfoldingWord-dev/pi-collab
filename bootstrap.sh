#!/bin/bash

# Install packages
apt-get update
apt-get -y install npm make nginx gzip git-core python libssl-dev pkg-config build-essential tmux

wget http://node-arm.herokuapp.com/node_latest_armhf.deb
dpkg -i node_latest_armhf.deb

# Create etherpad user
useradd -m etherpad
echo -e '\nexport PATH=$PATH:/usr/local/bin' >> /home/etherpad/.bashrc

su etherpad -c 'git clone http://github.com/ether/etherpad-lite.git /home/etherpad/etherpad-lite'

cd /home/etherpad/etherpad-lite
su etherpad -c 'sh bin/run.sh'
