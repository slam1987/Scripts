#!/bin/bash

echo " installing iptables package..."
yum -y install iptables iptables-services &> /dev/null

cp firewall_config.sh firewall_config.sh.bak

#Default policy configurations
def_input=$( cat main.conf | grep firewall_default_input | sed 's/firewall_default_input=//' | tr [a-z] [A-Z] )
def_output=$( cat main.conf | grep firewall_default_output | sed 's/firewall_default_output=//' | tr [a-z] [A-Z] )
def_forward=$( cat main.conf | grep firewall_default_forward | sed 's/firewall_default_forward=//' | tr [a-z] [A-Z] )
sed -i "s/INPUT_STATUS/$def_input/" firewall_config.sh
sed -i "s/OUTPUT_STATUS/$def_output/" firewall_config.sh
sed -i "s/FORWARD_STATUS/$def_forward/" firewall_config.sh

#DNS policy configurations
dns=$( sed -n 's/^firewall_allow_dns=//p' main.conf )
if ( $dns == "true" ); then
  echo " configuring firewall for unbound..."
  sed -i "s/\#DNS_SWITCH //g" firewall_config.sh
fi

#OSPF policy configurations
ospf=$( sed -n 's/^firewall_allow_ospf=//p' main.conf )
if ( $ospf == "true" ); then
  echo " configuring firewall for ospf..."
  sed -i 's/\#OSPF_SWITCH //g' firewall_config.sh
fi

#Mail policy configurations
mail=$( sed -n 's/^firewall_allow_dns=//p' main.conf )
if ( $mail == "true" ); then
  echo " configuring firewall for mail service..."
  sed -i 's/\#MAIL_SWITCH //g' firewall_config.sh
fi

#ICMP policy configurations
icmp=$( sed -n 's/^firewall_allow_icmp=//p' main.conf )
if ( $icmp == "true" ); then
  echo " configuring firewall for icmp..."
  sed -i 's/\#ICMP_SWITCH //g' firewall_config.sh
fi

#SSH policy configurations
ssh=$( sed -n 's/^firewall_allow_ssh=//p' main.conf )
if ( $ssh == "true" ); then
  echo " configuring firewall for ssh..."
  sed -i 's/\#SSH_SWITCH //g' firewall_config.sh
fi

echo " executing firewall configurations..."
/bin/bash firewall_config.sh

rm -f firewall_config.sh
mv firewall_config.sh.bak firewall_config.sh

echo -e " \e[32mfirewall configurations complete!\e[39m"
