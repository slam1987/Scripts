#!/bin/bash

# Setting variables
wifinterfaces=$( iw dev 2> /dev/null | grep Interface | sed 's/$*.Interface//g' | sed 's/ //' )
ipaddress=( $( cat main.conf | grep wificonf_ip_address | sed 's/wificonf_ip_address=//' | sed 's/,/\n/g' | sed 's/ //g'| sed 's/\/.*$//' ) )
prefix=( $( cat main.conf | grep wificonf_ip_address | sed 's/wificonf_ip_address=//' | sed 's/,/\n/g' | sed 's/ //g' | sed 's/.*\///' ) )

counter=0

# Creation of the wireless interface and hostapd config files
for x in $wifinterfaces
do
  sed "s/DEVICE_VAR/$x/" ifcfg-template-wireless | sed "s/ESSID_VAR/$x/" > /etc/sysconfig/network-scripts/ifcfg-$x
  sed -i "s/IPADDR_VAR/${ipaddress[$counter]}/" /etc/sysconfig/network-scripts/ifcfg-$x
  sed -i "s/PREFIX_VAR/${prefix[$counter]}/" /etc/sysconfig/network-scripts/ifcfg-$x
  let counter+=1
done

iwdev=$( iw dev 2> /dev/null )
if [[ $iwdev == "" ]]; then
  echo -e " \e[31mwarning: no wireless interfaces detected, no interfaces configured!\e[39m"
else
  echo -e " \e[32mwireless interface configurations complete!\e[39m"
fi
