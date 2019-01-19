
> This repo is pretty old now, and I've not used it in production for many years. Typically I would now use
> ansible to build the monit config files, but the idea can be applied if its adjusted to use systemd etc.

# monit-shared

monit-shared are some drop in scripts for monit.

monit is a free, open source process supervision tool for Unix and Linux.
<http://mmonit.com/monit/documentation/>


## what is it?

monit-shared a library of basic monitoring scripts for standard services on Linux.
The intention is to include the 80% of the 80/20 rule out of the box.


The monit scripts and the installer have only tested on a single CentOS 5.x box. This assumes redhat package filesystem paths, so should work anywhere with similar to rhel sementics and fs layout.


## Manual

You can pick and mix from the available scripts, by linking the individual them in step 3, or you can install them all in that step.

Alternatively there is an install script which will try to link the scripts matching services configured to run at init level 3 as detected by chkconfig.

        # sudo git clone git://github.com/tolland/monit-shared.git /usr/share/monit-shared
        # sudo chmod +x /usr/share/monit-shared/install.sh
        # sudo /usr/share/monit-shared/install.sh
        
        added chef-server
        Control file syntax OK


1. clone or export the project into your server;

        sudo git clone git://github.com/tolland/monit-shared.git /usr/share/monit-shared


2. review the scripts for anything interesting

        $ ls -1 /usr/share/monit-shared/monit.d
        chef-client.conf
        chef-server.conf
        openldap-server.conf


3. either install all the scripts, and get deluged with alerts;

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
        
        

