#!/bin/bash

# Installing necessary wireless packages
echo " installing wireless tools..."
yum -y install wireless-tools &> /dev/null

# Initialize wireless network interface configuration script

iw_dev=$( iw dev 2> /dev/null )
if [[ $iw_dev == "" ]]; then
  echo -e " \e[31mwarning: no wireless interfaces detected!\e[39m"
else
  echo " initializing wireless network interface configurations..."
  /bin/bash wifi_if_setup.sh
fi
