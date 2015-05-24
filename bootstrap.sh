#!/bin/bash

# Install packages
apt-get update
apt-get -y install npm make nginx gzip git-core python libssl-dev pkg-config build-essential tmux php5-fpm

cd /usr/local/src
git clone https://github.com/unfoldingWord-dev/pi-collab.git
cd pi-collab

wget http://node-arm.herokuapp.com/node_latest_armhf.deb
dpkg -i node_latest_armhf.deb

# Set up nginx
mkdir -p /var/www/vhosts/pi-collab/httpdocs
cp pi-collab.conf /etc/nginx/conf.d/
cp user_agent_block /etc/nginx/

# Set up DokuWiki
cd /usr/local/src/
wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
tar xfz dokuwiki-stable.tgz
mv dokuwiki-20* dokuwiki
rsync -havP dokuwiki/ /var/www/vhosts/pi-collab/httpdocs/
chown -R www-data:www-data /var/www/vhosts/pi-collab/httpdocs
cp users.auth.php /var/www/vhosts/pi-collab/httpdocs/conf/
cp local.php /var/www/vhosts/pi-collab/httpdocs/conf/
sed  -i "s/\/var\/run\/php5-fpm.sock/127.0.0.1:9000/" /etc/php5/fpm/pool.d/www.conf

/etc/init.d/php5-fpm restart
/etc/init.d/nginx restart

# Create etherpad user
useradd -m etherpad
echo -e '\nexport PATH=$PATH:/usr/local/bin' >> /home/etherpad/.bashrc

su etherpad -c 'git clone http://github.com/ether/etherpad-lite.git /home/etherpad/etherpad-lite'

cd /home/etherpad/etherpad-lite
su etherpad -c 'sh bin/installDeps.sh'

# Get etherpad running at init
npm i -g forever
cp etherpad-init /etc/init.d/etherpad
update-rc.d etherpad defaults
service etherpad start

# API Setup to pull from Unfoldingword.org
mkdir -p /var/www/vhosts/api.unfoldingword.org/httpdocs/
# rsync -havP --exclude=bible/jpg/1/SweetPublishingBibleIllustrations.zip rsync://uk.door43.org/api/ /var/www/vhosts/api.unfoldingword.org/httpdocs/
# rsync -havP --exclude=bible/jpg/1/SweetPublishingBibleIllustrations.zip rsync://jp.door43.org/api/ /var/www/vhosts/api.unfoldingword.org/httpdocs/
rsync -havP --exclude=bible/jpg/1/SweetPublishingBibleIllustrations.zip rsync://us.door43.org/api/ /var/www/vhosts/api.unfoldingword.org/httpdocs/

