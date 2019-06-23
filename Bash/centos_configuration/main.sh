#!/bin/bash

echo -e "\e[36m"
echo -e " _______ __                __               __        "
echo -e "|     __|  |_.---.-.-----.|  |.-----.--.--.|  |.-----."
echo -e "|__     |   _|  _  |     ||  ||  -__|  |  | |_||__ --|"
echo -e "|_______|____|___._|__|__||__||_____|___  |    |_____|"
echo -e "                                    |_____|           "
echo -e " \e[33m______ _______ _______ _______ "
echo -e "|   __ \   _   |     __|   |   |"
echo -e "|   __ <       |__     |       |"
echo -e "|______/___|___|_______|___|___|"
echo -e " \e[35m_______             __         __   "
echo -e "|     __|.----.----.|__|.-----.|  |_ "
echo -e "|__     ||  __|   _||  ||  _  ||   _|"
echo -e "|_______||____|__|  |__||   __||____|"
echo -e "                        |__|         "
echo -e "\e[39m"

sleep 15

# Selinux Configuration Switch
selinux=$( sed -n 's/^selinux=//p' main.conf)
if [[ $selinux == "true" ]]; then
  echo "performing selinux configurations..."
  /bin/bash selinux_setup.sh
else
  echo -e "\e[31mwarning: selinux will not be configured...\e[39m"
fi
echo ""

# Network Configuration Switch
network=$( sed -n 's/^netconf=//p' main.conf )
if [[ $network == "true" ]]; then
  echo "performing network configurations..."
  /bin/bash network_setup.sh
else
  echo -e "\e[31mwarning: network interfaces will not be configured...\e[39m"
fi
echo ""

# Routing Configuration Switch
routing=$( sed -n 's/^routing=//p' main.conf )
if [[ $routing == "true" ]]; then
  echo "enabling routing..."
  /bin/bash routing.sh
else
  echo -e "\e[31mwarning: routing will not be enabled!\e[39m"
fi

# Base Configuration Switch
baseconf=$( sed -n 's/^baseconfig=//p' main.conf )
if ( $baseconf == "true" ); then
  echo "Performing base configurations..."
  /bin/bash base_configuration.sh
else
  echo -e "\e[31mwarning: base configurations will not be configured!\e[39m"
fi
echo ""

# Wireless Configuration Switch
wificonf=$( sed -n 's/^wificonf=//p' main.conf )
if ( $wificonf == "true" ); then
  echo "performing wireless network configurations..."
  /bin/bash wifi_network_setup.sh
else
  echo -e "\e[31mwarning: wireless interfaces will not be configured!\e[39m"
fi
echo ""

# Hostapd Configuration Switch
hostapd=$( sed -n 's/^hostapd=//p' main.conf )
if [[ $hostapd == "true" ]]; then
  echo "performing hostapd configurations..."
  /bin/bash hostapd_setup.sh
else
  echo echo "\e[31mwarning: hostapd will not be configured...\e[39m"
fi
echo ""

# OSPF Configuration Switch
ospf=$( sed -n 's/^ospf=//p' main.conf )
if [[ $ospf == "true" ]]; then
  echo "performing ospf configurations..."
  /bin/bash ospf.sh
else
  echo -e "\e[31mwarning: ospf will not be configured...\e[39m"
fi
echo ""

# NSD Configuration Switch
nsd=$( sed -n 's/^nsd=//p' main.conf )
if ( $nsd == "true" ); then
  echo "Performing NSD configurations..."
  /bin/bash nsd.sh
else
  echo -e "\e[31mwarning: nsd will not be configured...\e[39m"
fi
echo ""

# Unbound Configuration Switch
unbound=$( sed -n 's/^unbound=//p' main.conf )
if ( $unbound == "true" ); then
  echo "performing unbound configurations..."
  /bin/bash unbound.sh
else
  echo -e "\e[31mwarning: unbound will not be configured...\e[39m"
fi
echo ""

# DHCP Configuration Switch
dhcp=$( sed -n 's/^dhcp=//p' main.conf )
if ( $dhcp == "true" ); then
  echo "performing dhcp configurations..."
  /bin/bash dhcp.sh
else
  echo -e "\e[31mwarning: dhcp will not be configured...\e[39m"
fi
echo ""

#Postfix Configuration Switch
postfix=$( sed -n 's/^postfix=//p' main.conf )
if ( $postfix == "true" ); then
  echo "performing postfix configurations..."
  /bin/bash postfix.sh
else
  echo -e "\e[31mwarning: postfix will not be configured...\e[39m"
fi
echo ""

#Dovecot Configuration Switch
dovecot=$( sed -n 's/^dovecot=//p' main.conf )
if ( $dovecot == "true" ); then
  echo "performing dovecot configurations..."
  /bin/bash dovecot.sh
else
  echo -e "\e[31mwarning: dovecot will not be configured...\e[39m"
fi
echo ""

#IPtables Configuration Switch
firewall=$( sed -n 's/^firewall=//p' main.conf )
if ( $firewall == "true" ); then
  echo "performing firewall configurations..."
  /bin/bash firewall.sh
else
  echo -e "\e[31mwarning: firewall will not be configured...\e[39m"
fi
echo ""

# Start Services
echo "starting services..."
/bin/bash service_start.sh

echo ""
echo ""
echo ""
echo -e "\e[32configuration script complete!\e[39m"
