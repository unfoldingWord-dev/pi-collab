#!/bin/bash

# Example: $0 en pt-br
# ...sets up languages in /var/www/vhosts/pi-collab/httpdocs/data/pages/en
#                     and /var/www/vhosts/pi-collab/httpdocs/data/pages/pt-br respectively

set -x  # show your work

WEBDIR=/var/www/vhosts/pi-collab/httpdocs
# WEBDIR=/var/tmp  # for testing only
PAGESDIR=$WEBDIR/data/pages
# mkdir -p $PAGESDIR  # for testing only

for LANG in "$@"
do
    git clone https://github.com/Door43/d43-$LANG.git $PAGESDIR/$LANG
    chown -R www-data:www-data $PAGESDIR/$LANG
    NAME=$(awk "\$1==\"$LANG\"" $WEBDIR/lib/plugins/translation/lang/langnames.txt | cut -f 2)
    echo "* [[:$LANG:home|$NAME ($LANG)]]" >> $PAGESDIR/home.txt
done
