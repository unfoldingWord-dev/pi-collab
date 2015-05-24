#!/bin/bash

# Install packages
apt-get update
apt-get -y install npm make nginx gzip git-core python libssl-dev pkg-config build-essential tmux php5-fpm

SRC=/usr/local/src
cd $SRC

# Install node
wget http://node-arm.herokuapp.com/node_latest_armhf.deb
dpkg -i node_latest_armhf.deb

REPO=pi-collab
git clone https://github.com/unfoldingWord-dev/$REPO.git
cd $SRC/$REPO

# Set up nginx
WEBDIR=/var/www/vhosts/pi-collab/httpdocs
mkdir -p $WEBDIR
cp pi-collab.conf /etc/nginx/conf.d/
cp user_agent_block /etc/nginx/

# Set up DokuWiki
cd $SRC
wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
tar xfz dokuwiki-stable.tgz
mv dokuwiki-20* dokuwiki
rsync -havP dokuwiki/ $WEBDIR/
chown -R www-data:www-data $WEBDIR
cp $SRC/$REPO/users.auth.php $SRC/$REPO/local.php $WEBDIR/conf/
cp $SRC/$REPO/home.txt $SRC/$REPO/sidebar.txt     $WEBDIR/data/pages/
sed  -i "s/\/var\/run\/php5-fpm.sock/127.0.0.1:9000/" /etc/php5/fpm/pool.d/www.conf

# DokuWiki Plugin setup
cd $WEBDIR/lib/plugins/
git clone https://github.com/Door43/dokuwiki-plugin-translation.git translation
git clone https://github.com/Door43/dw-gitcommit.git gitcommit


service php5-fpm restart
service nginx restart

# Create etherpad user
useradd -m etherpad
echo -e '\nexport PATH=$PATH:/usr/local/bin' >> /home/etherpad/.bashrc

su etherpad -c 'git clone http://github.com/ether/etherpad-lite.git /home/etherpad/etherpad-lite'

cd /home/etherpad/etherpad-lite
su etherpad -c 'sh bin/installDeps.sh'

# Get etherpad running at init
npm i -g forever
cp $SRC/$REPO/etherpad-init /etc/init.d/etherpad
chmod +x /etc/init.d/etherpad
update-rc.d etherpad defaults
service etherpad restart

# API Setup to pull from Unfoldingword.org
mkdir -p /var/www/vhosts/api.unfoldingword.org/httpdocs/
rsync -havP --exclude=obs/jpg/1/en/obs-images-2160px.zip --exclude=bible/jpg/1/SweetPublishingBibleIllustrations.zip rsync://us.door43.org/api/ /var/www/vhosts/api.unfoldingword.org/httpdocs/
# ...or...                                                                                                                   uk.door43.org
# ...or...                                                                                                                   jp.door43.org

