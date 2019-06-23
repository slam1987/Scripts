#!/bin/bash

iw_dev=$( iw dev 2> /dev/null )
if [[ $iw_dev == "" ]]; then
  echo -e " \e[31mwarning: no wireless interfaces detected! Hostapd will remain stopped.\e[39m"
else
  echo " Starting service: hostapd..."
  systemctl daemon-reload
  systemctl start hostapd
fi

echo " starting service: zebra..."
systemctl start zebra

echo " starting service: ospfd..."
systemctl start ospfd

echo " starting service: nsd..."
systemctl start nsd

echo " starting service: unbound..."
systemctl start unbound

echo " starting service: dhcpd..."
systemctl start dhcpd

echo " starting service: postfix..."
systemctl start postfix

echo " starting service: dovecot..."
systemctl start dovecot

echo " starting service: iptables..."
systemctl start iptables

echo -e " \e[32service start complete!\e[39m"
