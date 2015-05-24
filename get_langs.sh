#!/bin/bash

# Example: $0 en pt-br
# ...sets up languages in /var/www/vhosts/pi-collab/httpdocs/data/pages/en
#                     and /var/www/vhosts/pi-collab/httpdocs/data/pages/pt-br respectively

set -x  # show your work

WEBDIR=/var/www/vhosts/pi-collab/httpdocs/data/pages
# WEBDIR=/var/tmp  # for testing

for LANG in "$@"
do
    git clone https://github.com/Door43/d43-$LANG.git $WEBDIR/$LANG
    chown -R www-data:www-data $WEBDIR/$LANG
    echo "* [[:$LANG:home|$LANG ($LANG)]]" >> $WEBDIR/home.txt
done
