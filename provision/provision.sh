# provision.sh
#
# This file is specified in Vagrantfile and is loaded by Vagrant as the primary
# provisioning script whenever the commands `vagrant up`, `vagrant provision`,
# or `vagrant reload` are used. It provides all of the default packages and
# configurations included with Varying Vagrant Vagrants. 
# It's worth noting that you dont' need the normal #!/bin/bash for this included file

## since we are generating from Mac or Windows this is needed 
apt-get install dos2unix
apt-get install pv

cd /srv/www/scripts/
find . -type f -exec dos2unix {} \; 


cd /srv/www/scripts/
. install-functions.sh

#so we would put this as a loop over and detect if kept this way
cd /srv/www/scripts/
. magento/functions.sh


if [[ has_network ]]
then

    cd /srv/www/scripts/
    . main-install.sh

    #check and install wp
    cd /srv/www/scripts/
    . db-install.sh   

else
	echo -e "\nNo network available, skipping network installations"
fi
# Add any custom domains to the virtual machine's hosts file so that it
# is self aware. Enter domains space delimited as shown with the default.
DOMAINS='local.general.dev'
if ! grep -q "$DOMAINS" /etc/hosts
then echo "127.0.0.1 $DOMAINS" >> /etc/hosts
fi
