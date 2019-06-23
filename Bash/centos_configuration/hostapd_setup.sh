#!/bin/bash

echo " installing hostapd..."
yum -y install hostapd &> /dev/null

pwd_array=( $( cat main.conf | grep hostapd_password | sed 's/hostapd_password=//' | sed 's/,/\n/g' | sed 's/ //g' ) )
interfaces=$( iw dev 2> /dev/null | grep Interface | sed 's/$*.Interface//g' | sed 's/ //' )

counter=0
for x in $interfaces; do
  sed "s/INTERFACE/$x/" hostapd_template | sed "s/SSID/$x/" | sed "s/PASSWORD/${pwd_array[$counter]}/" > /etc/hostapd/$x.conf
  let counter+=1
done

rm -f /etc/hostapd/hostapd.conf > /dev/null 2>&1
cp hostapd.service.template hostapd.service.template.bak

ref_int=$( ls /etc/hostapd/ )
for x in $ref_int; do
  sed -i -e '/ExecStart=\/usr\/sbin\/hostapd/s/$/ \/etc\/hostapd\/'$x'/' hostapd.service.template
done

sed -i '8s/$/ -P \/run\/hostapd.pid \-B/' hostapd.service.template

rm -f /usr/lib/systemd/system/hostapd.service
mv hostapd.service.template /usr/lib/systemd/system/hostapd.service
mv hostapd.service.template.bak hostapd.service.template

iwdev=$( iw dev 2> /dev/null )
if [[ $iwdev == "" ]]; then
  echo -e " \e[31mwarning: no wireless interfaces detected!\e[39m"
else
  echo -e " \e[32mhostapd configurations complete!\e[39m"
fi
