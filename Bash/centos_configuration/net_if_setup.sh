#!/bin/bash

# Refresh
refresh=$( ls /etc/sysconfig/network-scripts/ | grep ifcfg )
for x in $refresh; do
  if [[ $x != "ifcfg-lo" ]]; then
    rm -f $x
  fi
done

echo " configuring network interfaces..."
# Create network interface configuration files
ipaddress=$( cat main.conf | grep netconf_ip_address= | sed 's/netconf_ip_address=//' | sed 's/,/\n/g' | sed 's/ //g' | sed 's/\/.*$//' )
prefix=$( cat main.conf | grep netconf_ip_address= | sed 's/netconf_ip_address=//' | sed 's/,/\n/g' | sed 's/ //g' | sed 's/.*\///' )
gateway=$( cat main.conf | grep netconf_default_gateway= | sed 's/netconf_default_gateway=//' )
counter=0
for x in $ipaddress
do
  sed "s/NAME_VAR/eth$counter/" ifcfg-template | sed "s/DEVICE_VAR/eth$counter/" | sed "s/IPADDR_VAR/$x/" > /etc/sysconfig/network-scripts/ifcfg-eth$counter
  let counter+=1;
  prefixline=$( echo $prefix | sed 's/ /\n/g' | sed -n "$counter"p )
  let counter-=1;
  sed -i "s/PREFIX_VAR/$prefixline/" /etc/sysconfig/network-scripts/ifcfg-eth$counter
  let counter+=1
done
sed -i "s/GATEWAY_VAR/$gateway/" /etc/sysconfig/network-scripts/ifcfg-eth0
mv /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/temp-eth0
secondaryinterfaces=$( ls /etc/sysconfig/network-scripts/ | grep ifcfg-eth )
for i in $secondaryinterfaces
do
  sed -i '/DEFROUTE="yes"/d' /etc/sysconfig/network-scripts/$i
  sed -i '/GATEWAY="GATEWAY_VAR"/d' /etc/sysconfig/network-scripts/$i
done
mv /etc/sysconfig/network-scripts/temp-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0

echo -e " \e[32mnetwork interface configurations complete!\e[39m"
