#!/bin/bash

# Example: $0 en pt-br
# Does:
#   git clone https://github.com/Door43/d43-en.git    /var/www/vhosts/pi-collab/httpdocs/data/pages/en
#   chown -R www-data:www-data                        /var/www/vhosts/pi-collab/httpdocs/data/pages/en
#   git clone https://github.com/Door43/d43-pt-br.git /var/www/vhosts/pi-collab/httpdocs/data/pages/pt-br
#   chown -R www-data:www-data                        /var/www/vhosts/pi-collab/httpdocs/data/pages/pt-br

set -x  # show your work

for LANG in "$@"
do
#   WEB_HOME="/var/www/vhosts/pi-collab/httpdocs/data/pages/$LANG"
    WEB_HOME="/var/tmp/$LANG"  # Testing
    git clone https://github.com/Door43/d43-$LANG.git $WEB_HOME
    chown -R www-data:www-data $WEB_HOME
done
