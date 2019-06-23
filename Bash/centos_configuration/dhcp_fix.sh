#!/bin/bash


# DHCP repair script
rm -f /etc/dhcp/dhcpd.conf 2> /dev/null
template=$( echo dhcpd.conf.template )
cp $template $template.bak
dhcp_networks=$( cat main.conf | grep dhcp_networks | sed 's/dhcp_networks=//' | sed 's/,/\n/g' )
dhcp_networks_ip=$( cat main.conf | grep dhcp_networks | sed 's/dhcp_networks=//' | sed 's/,/\n/g' | sed 's/\/.*$//' )
dhcp_networks_ip_array=$( cat main.conf | grep dhcp_networks | sed 's/dhcp_networks=//' | sed 's/,/\n/g' | sed 's/\/.*$//' )
interfaces_array=( $( ifconfig | grep flags | sed 's/:.*$//' | sed '/^lo/d' ) )
interfaces=$( ifconfig | grep flags | sed 's/:.*$//' | sed '/^lo/d' )
for x in $interfaces; do
  ifdown $x && ifup $x
done
second_interfaces=$( ls /etc/sysconfig/network-scripts/ | grep ifcfg | sed 's/ifcfg-//g')
for x in $second_interfaces; do
  ifdown $x && ifup $x
done
sleep 10

# Options Configuration
domain_name=$( cat main.conf | grep nsd_domain_name | sed 's/nsd_domain_name=//' )
domain_ip=$( cat main.conf | grep unbound_bind_ip | sed 's/unbound_bind_ip=//' )
sed -i "s/DOMAIN_NAME/$domain_name/" $template
sed -i "s/DNS_IP/$domain_ip/" $template

# Subnets Configuration
for x in $interfaces; do
  isolate_ip=$( ifconfig $x | sed -n '/inet /p' | sed 's/netmask.*$//' | sed 's/inet //' | sed 's/ //g' )
  for i in $dhcp_networks_ip; do
    if [[ $i == $isolate_ip ]]; then
      echo $x >> interfaces.temp
      echo $i >> ipaddress.temp
    fi
  done
done
dhcp_interface=( $( cat interfaces.temp ) )
ip_array=( $( cat ipaddress.temp ) )
ip_range_array=( $( cat main.conf | grep dhcp_ip_range | sed 's/dhcp_ip_range=//' | sed 's/,/\n/g' ) )
counter=0
for x in $dhcp_networks; do
  network_id=$( ipcalc $x -n | sed 's/NETWORK=//' )
  netmask=$( ipcalc $x -m | sed 's/NETMASK=//' )
  sed -i -e "/SUBNET_AREA/ a \ \nsubnet $network_id netmask $netmask \{\n\tinterface ${dhcp_interface[$counter]}\;\n\toption routers ${ip_array[$counter]}\;\n\trange ${ip_range_array[$counter]}\;\n\t}" $template
  sed -i '/range/ s/-/ /' $template
  let counter+=1
done
rm -f interfaces.temp
rm -f ipaddress.temp
sed -i '/SUBNET_AREA/d' $template

# Reservations Configuration
res_mac=$( cat main.conf | grep dhcp_reservation_mac | sed 's/dhcp_reservation_mac=//' | sed 's/,/\n/g' )
res_ip_array=( $( cat main.conf | grep dhcp_reservation_ip | sed 's/dhcp_reservation_ip=//' | sed 's/,/\n/g' ) )
counter2=0
for x in $res_mac; do
  sed -i "/HOST_AREA/ a \ \n\thardware ethernet $x\;\n\tfixed-address ${res_ip_array[$counter2]}\;" $template
  let counter2+=1
done

sed -i 's/HOST_AREA//' $template
cp $template /etc/dhcp/dhcpd.conf
mv $template.bak $template

# Failure Check
dhcp_int_check=$( cat /etc/dhcp/dhcpd.conf | grep "interface ;" )
if [[ $dhcp_int_check != "" ]]; then
  echo -e " \e[31mwarning: dhcp configuration error! Please review main.conf.\e[39m"
else
  echo -e " \e[32mdhcp configurations complete!\e[39m"
fi
