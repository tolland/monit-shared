#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo "this script needs to be run as root"
	exit 1
fi

for i in "$@"; do
    if [ "$i" = "--debug" -o "$i" = "-d" ]; then
        debug=1
    fi
done

#loops over the init scripts in /etc/init.d for service names
#checks those against enabled services with chkconfig
#and then adds any config files that it can find

init_dir="/etc/init.d"
monit_shared="/usr/share/monit-shared"
monit_dir="/etc/monit.d"
##does not work for init levels other than 3
init_level=3

for foo in `ls ${init_dir}`
do

    if [ ! -x "${init_dir}/$foo" -o $foo = "functions" ]; then
            [ $debug ] && echo "discarding $foo"
          continue
      fi
      
    #are we always in init levell 3?, 

    state="`chkconfig --list ${foo} 2>/dev/null | awk '{print $5}' | awk -F":" '{print $2}'`" 
    if [ "$state" = "on" ]
    then
      [ $debug ] && echo "trying $foo"
        [ -f ${monit_shared}/monit.d/${foo}.conf ] && \
        [ ! -L ${monit_dir}/${foo}.conf ] && \
        ln -s ${monit_shared}/monit.d/${foo}.conf /etc/monit.d/        && \
        echo "added $foo"
    fi    

    if [ "$state" = "off" ]
    then
      [ $debug ] && echo "removing $foo"
        [ -L /etc/monit.d/${foo}.conf ] && \
		rm -f /etc/monit.d/${foo}.conf        && \
        echo "removed $foo"
    fi    
done

# have chef handle the filesystem checks

[ -f /etc/monit.d/filesystem.conf ] || \
cp ${monit_shared}/monit.d/filesystem.conf /etc/monit.d/

# handle any cases where the service has been removed;
# so want to break any links between /etc/monit.d and /usr/shared/monit-shared
# which were created by monit-shared

# @todo this is all nasty nasty

rtrim() {
    local var=$1
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

for foo in `find /etc/monit.d/ -type l -print0 | xargs -0 echo`
do

svc=$(basename `basename $foo` .conf)

    if [ ! -x /etc/init.d/$svc -a -L /etc/monit.d/$svc.conf ]; then 
#        if [! -x /etc/init.d/$(basename `basename $foo` .conf) ]; then
#        find $foo -type l -exec ls -lh {} \; 
        rm -f /etc/monit.d/$svc.conf
#        fi           
      fi
done

monit -t



