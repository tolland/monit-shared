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
    if [ "`chkconfig --list ${foo} 2>/dev/null | awk '{print $5}' | awk -F":" '{print $2}'`" = "on" ]
    then
      [ $debug ] && echo "trying $foo"
        [ -f ${monit_shared}/monit.d/${foo}.conf ] && \
        [ ! -L ${monit_dir}/${foo}.conf ] && \
        ln -s ${monit_shared}/monit.d/${foo}.conf /etc/monit.d/        && \
        echo "added $foo"
    fi    
done

[ -h /etc/monit.d/filesystem.conf ] || \
ln -s ${monit_shared}/monit.d/filesystem.conf /etc/monit.d/

monit -t

