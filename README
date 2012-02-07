
currently only tested on a single CentOS 5.x box. Assumes redhat package filesystem paths.

you can pick and mix, by linking the individual scripts in step 3, or you can install them all in that step.

Alternatively there is an install script which will try to link the scripts matching services configured to run at init level 3 as detected by chkconfig.

# sudo git clone git://github.com/tolland/monit-shared.git /usr/share/monit-shared
# sudo chmod +x /usr/share/monit-shared/install.sh
# sudo /usr/share/monit-shared/install.sh

added chef-server
Control file syntax OK


1.
clone or export the project into your server;

sudo git clone git://github.com/tolland/monit-shared.git /usr/share/monit-shared


2.
review the scripts for anything interesting

$ ls -1 /usr/share/monit-shared/monit.d
chef-client.conf
chef-server.conf
openldap-server.conf


3.
either install all the scripts, and get deluged with alerts;
sudo ln -s -t /etc/monit.d/ /usr/share/monit-shared/monit.d/* 

Or just link the ones you want to monit;
sudo ln -s /usr/share/monit/monit.d/chef-client.conf /etc/monit.d/chef-client.conf

4.
check the config and restart monit;

# monit -t 
Control file syntax OK


5.
restart monit.

# service monit restart
Stopping monit: 
                                                           [  OK  ]
Starting monit: Starting monit daemon with http interface at [*:2812]
                                                           [  OK  ]
