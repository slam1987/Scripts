#!/bin/bash

####################################
### UNBOUND CONFIGURATION SCRIPT ###
####################################

# Install unbound
echo " installing unbound package..."
yum -y install unbound &> /dev/null

# Download root hints
yum -y install wget &> /dev/null
wget -S -N https://www.internic.net/domain/named.cache -O /etc/unbound/root.hints &> /dev/null

# START >>> Configuration for unbound.conf
template=$( echo unbound.conf.template )
cp $template $template.bak

# Interfaces
bind_interfaces=$( cat main.conf | grep unbound_bind_ip | sed 's/unbound_bind_ip=//' | sed 's/,/\n/g' | sed 's/ //g' )
for x in $bind_interfaces; do
  sed -i "/BIND_INTERFACES/ a \ \tinterface: $x" $template
done
sed -i "/BIND_INTERFACES/d" $template

# Port number
port_number=$( cat main.conf | grep unbound_port | sed 's/unbound_port=//' )
sed -i "s/PORT_NUMBER/$port_number/" $template

# Access control: allow
access_allow=$( cat main.conf | grep unbound_access_allow | sed 's/unbound_access_allow=//' | sed 's/,/\n/g' | sed 's/ //g' )
for x in $access_allow; do
  sed -i "/ACCESS_CONTROL/ a \ \taccess-control: $x allow" $template
done

# Access control: deny
access_deny=$( cat main.conf | grep unbound_access_deny | sed 's/unbound_access_deny=//' | sed 's/,/\n/g' | sed 's/ //g' )
if [[ $access_deny != "" ]]; then
  for x in $access_deny; do
    sed -i "/ACCESS_CONTROL/ a \ \taccess-control: $x deny" $template
  done
fi
sed -i '/ACCESS_CONTROL/d' $template

# Stub zones
stub_names=$( cat main.conf | grep unbound_stub_zones | sed 's/unbound_stub_zones=//' | sed 's/,/\n/g' | sed 's/ //g' )
stub_ip=$( cat main.conf | grep unbound_stub_ip | sed 's/unbound_stub_ip=//' | sed 's/,/\n/g' | sed 's/ //g' | sed 's/\/.*$//' )
stub_ip_array=( $( cat main.conf | grep unbound_stub_ip | sed 's/unbound_stub_ip=//' | sed 's/,/\n/g' | sed 's/ //g' | sed 's/\/.*$//' ) )
stub_prefix_array=( $( cat main.conf | grep unbound_stub_ip | sed 's/unbound_stub_ip=//' | sed 's/,/\n/g' | sed 's/ //g' | sed 's/.*\///' ) )

counter_temp=0
for x in $stub_ip; do
  touch ip_stub_temp$counter_temp
  echo $x >> ip_stub_temp$counter_temp
  let counter_temp+=1
done

counter_list=0
for x in $stub_ip; do
  sed 's/\./\n/g' ip_stub_temp$counter_list > ip_stub_list$counter_list
  rm -f ip_stub_temp$counter_list
  let counter_list+=1
done

counter_reverse=0
touch final_values_unbound
check=$( ls | grep ip_stub_list )
for x in $check; do
  var0=$( cat $x | sed -n 4p )
  var1=$( cat $x | sed -n 3p )
  var2=$( cat $x | sed -n 2p )
  var3=$( cat $x | sed -n 1p )
  echo $var0.$var1.$var2.$var3.in-addr.arpa >> ip_stub_reversed$counter_reverse
  cat ip_stub_reversed$counter_reverse >> final_values_unbound
  rm -f ip_stub_reversed$counter_reverse
  let counter_reverse+=1
  rm -f $x
done

counter_stub=0
values_array=( $( cat final_values_unbound ) )
for x in $stub_names; do
  if [[ ${stub_prefix_array[$counter_stub]} -le 8 ]]; then
    mod=$( echo ${values_array[$counter_stub]} | sed 's/\./HOLD/' | sed 's/^.*HOLD//' | sed 's/\./HOLD/' | sed 's/^.*HOLD//' | sed 's/\./HOLD/' | sed 's/^.*HOLD//' )
    sed -i "/STUB_ZONE_START/ a stub-zone:\n\tname: \"$x\"\n\tstub-addr: ${stub_ip_array[$counter_stub]}\nstub-zone:\n\tname: \"$mod\"\n\tstub-addr: ${stub_ip_array[$counter_stub]}\n" $template
  elif [[ ${stub_prefix_array[$counter_stub]} -le 16 ]]; then
    mod=$( echo ${values_array[$counter_stub]} | sed 's/\./HOLD/' | sed 's/^.*HOLD//' | sed 's/\./HOLD/' | sed 's/^.*HOLD//' )
    sed -i "/STUB_ZONE_START/ a stub-zone:\n\tname: \"$x\"\n\tstub-addr: ${stub_ip_array[$counter_stub]}\nstub-zone:\n\tname: \"$mod\"\n\tstub-addr: ${stub_ip_array[$counter_stub]}\n" $template
  elif [[ ${stub_prefix_array[$counter_stub]} -le 24 ]]; then
    mod=$( echo ${values_array[$counter_stub]} | sed 's/\./HOLD/' | sed 's/^.*HOLD//' )
    sed -i "/STUB_ZONE_START/ a stub-zone:\n\tname: \"$x\"\n\tstub-addr: ${stub_ip_array[$counter_stub]}\nstub-zone:\n\tname: \"$mod\"\n\tstub-addr: ${stub_ip_array[$counter_stub]}\n" $template
  fi
  let counter_stub+=1
done
sed -i '/STUB_ZONE_START/d' $template

# Private domain
domain_name=$( cat main.conf | grep nsd_domain_name | sed 's/nsd_domain_name=//' )
sed -i "s/PRIVATE_DOMAIN/$domain_name/" $template
domain_prefix=$( cat main.conf | grep unbound_private_domain_ip | sed 's/unbound_private_domain_ip=//' | sed 's/.*\///' )
domain_ip=$( cat main.conf | grep unbound_private_domain_ip | sed 's/unbound_private_domain_ip=//' | sed 's/$*.\///' )
domain_ip_list_rev_array=( $( cat main.conf | grep unbound_private_domain_ip | sed 's/unbound_private_domain_ip=//' | sed 's/$*.\///' | sed 's/\./\n/g' | tac ) )
reversed_ip=$( echo ${domain_ip_list_rev_array[0]}.${domain_ip_list_rev_array[1]}.${domain_ip_list_rev_array[2]}.${domain_ip_list_rev_array[3]}.in-addr.arpa. )

for x in $domain_prefix; do
  if [[ $x -le 8 ]]; then
    pvar=$( echo $reversed_ip | sed 's/\./HOLD/' | sed 's/^.*HOLD//' | sed 's/\./HOLD/' | sed 's/^.*HOLD//' | sed 's/\./HOLD/' | sed 's/^.*HOLD//' )
    sed -i "s/LOCAL_ZONE/$pvar/" $template
  elif [[ $x -le 16 ]]; then
    pvar=$( echo $reversed_ip | sed 's/\./HOLD/' | sed 's/^.*HOLD//' | sed 's/\./HOLD/' | sed 's/^.*HOLD//' )
    sed -i "s/LOCAL_ZONE/$pvar/" $template
  elif [[ $x -le 24 ]]; then
    pvar=$( echo $reversed_ip | sed 's/\./HOLD/' | sed 's/^.*HOLD//' )
    sed -i "s/LOCAL_ZONE/$pvar/" $template
  fi
done

rm -f final_values_unbound
rm -f /etc/unbound/unbound.conf
mv $template /etc/unbound/unbound.conf
mv $template.bak $template

echo -e " \e[32munbound configurations complete!\e[39m"
