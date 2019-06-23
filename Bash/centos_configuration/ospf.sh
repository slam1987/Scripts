#!/bin/bash

echo " installing quagga package..."
yum -y install quagga &> /dev/null

# Configuration for /etc/quagga/ospf.conf
cp ospfd.conf.template ospfd.conf.template.bak
cp zebra.conf.template zebra.conf.template.bak
interfaces=$( ls /etc/sysconfig/network-scripts/ | grep ifcfg | sed 's/ifcfg-//' )
routerid=$( cat main.conf | grep netconf_ip_address= | sed 's/netconf_ip_address=//' | sed 's/,/\n/g' | sed 's/ //g'| sed 's/\/.*$//' | head -n 1 )
ipaddress=$( cat main.conf | grep netconf_ip_address= | sed 's/netconf_ip_address=//' | sed 's/,/\n/g' | sed 's/ //g' )
for x in $interfaces
do
  sed -i "/INTERFACES/ a interface $x" ospfd.conf.template
  sed -i "/$x/ a !" ospfd.conf.template
done
sed -i '/INTERFACES/d' ospfd.conf.template
sed -i "s/RTR-ID/$routerid/" ospfd.conf.template
for i in $ipaddress
do
  sed -i "/NET_START/ a network $i area 0.0.0.0" ospfd.conf.template
done
sed -i '/NET_START/d' ospfd.conf.template
sed -i 's/^network/ network/' ospfd.conf.template

# Configurations for /etc/quagga/zebra.conf
for y in $interfaces
do
  sed -i "/INTERFACES/ a interface $y" zebra.conf.template
  sed -i "/$y/ a !" zebra.conf.template
done
sed -i '/INTERFACES/d' zebra.conf.template
counter=0
for k in $ipaddress
do
  sed -i "/eth$counter/ a ip address $k" zebra.conf.template
  let counter+=1
done
sed -i 's/^ip address/ ip address/' zebra.conf.template
sed -i '/^ ip address/ a ipv6 nd suppress-ra' zebra.conf.template
sed -i 's/^ipv6 nd supress-ra/ ipv6 nd suppress-ra/' zebra.conf.template
rm -f /etc/quagga/ospf.conf
rm -f /etc/quagga/zebra.conf
mv ospfd.conf.template /etc/quagga/ospfd.conf
cp /etc/quagga/ospfd.conf /etc/quagga/ospfd.conf.sav
mv zebra.conf.template /etc/quagga/zebra.conf
cp /etc/quagga/zebra.conf /etc/quagga/zebra.conf.sav
mv ospfd.conf.template.bak ospfd.conf.template
mv zebra.conf.template.bak zebra.conf.template
chown -R quagga:quagga /etc/quagga/

echo -e " \e[32mospf configurations complete!\e[39m"
