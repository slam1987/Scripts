#!/bin/bash

echo " installing nsd package..."
yum -y install nsd &> /dev/null

ipbind=$( cat main.conf | grep nsd_bind_ip | sed 's/nsd_bind_ip=//' )
domain=$( cat main.conf | grep nsd_domain_name | sed 's/nsd_domain_name=//' )
subzone=$( cat main.conf | grep nsd_zones_name | sed 's/nsd_zones_name=//' | sed 's/,/\n/g' | sed 's/ //g' )
subzone1=( $( cat main.conf | grep nsd_zones_name | sed 's/nsd_zones_name=//' | sed 's/,/\n/g' | sed 's/ //g' ) )
zoneip=( $( cat main.conf | grep nsd_zones_ip | sed 's/nsd_zones_ip=//' | sed 's/,/\n/g' | sed 's/ //g' ) )

cp nsd.conf.template nsd.conf.template.bak
sed -i "s/IP_BIND/$ipbind/" nsd.conf.template
sed -i "/ZONE_AREA/ a zone:\n\tname: \"$domain\"\n\tzonefile: \"$domain.zone\"\n\nSUB_ZONE_HOLDER" nsd.conf.template
sed -i '/ZONE_AREA/d' nsd.conf.template

counter=0
for x in $subzone; do
  touch ip_temp$counter
  echo ${zoneip[$counter]} >> ip_temp$counter
  let counter+=1
done

### IP address lister
counter_small=0
for i in $subzone; do
  sed 's/\./\n/g' ip_temp$counter_small > ip_list$counter_small
  rm -f ip_temp$counter_small
  let counter_small+=1
done

### IP address reverser
counter_x=0
touch final_values
check=$( ls | grep ip_list )
for u in $check; do
  var1=$( cat $u | sed -n 3p )
  var2=$( cat $u | sed -n 2p )
  var3=$( cat $u | sed -n 1p )
  echo $var1.$var2.$var3.in-addr.arpa >> ip_reversed$counter_x
  cat ip_reversed$counter_x >> final_values
  rm -f ip_reversed$counter_x
  let counter_x+=1
  rm -f $u
done

### nsd.conf creation
zone_list=$( cat final_values )
counter_again=0
for k in $zone_list; do
  sed -i "/SUB_ZONE_HOLDER/ a zone:\n\tname: \"$k\"\n\tzonefile: \"${subzone1[$counter_again]}\.zone\"\n" nsd.conf.template
  let counter_again+=1
done

sed -i '/SUB_ZONE_HOLDER/d' nsd.conf.template

rm -f /etc/nsd/nsd.conf
mv nsd.conf.template /etc/nsd/nsd.conf
mv nsd.conf.template.bak nsd.conf.template

cp domain.zone.template domain.zone.template.bak

rtrname=$( cat main.conf | grep nsd_router_a_name | sed 's/nsd_router_a_name=//' )
soa_head=$( cat main.conf | grep nsd_domain_name | sed 's/nsd_domain_name=//' | sed "s/\./$rtrname\./")
domain_name=$( cat main.conf | grep nsd_domain_name | sed 's/nsd_domain_name=//' )
soa_email=$( cat main.conf | grep nsd_soa_email | sed 's/nsd_soa_email=//' )
sed -i "s/SOA_HEADER/$soa_head/" domain.zone.template
sed -i "s/NS_RECORD_NAME/$rtrname\.$domain_name/" domain.zone.template
sed -i "s/EMAIL_HEADER/$soa_email/" domain.zone.template

counter_zone=0
for x in $subzone; do
  sed -i "/RECORDS_START/ a $x\t\t\tIN\tA\t${zoneip[$counter_zone]}" domain.zone.template
  let counter_zone+=1
done

sed -i 's/RECORDS_START//' domain.zone.template

mx_name=$( cat main.conf | grep nsd_mx_records | sed 's/nsd_mx_records=//' | sed 's/,/\n/g' | sed 's/ //g' )
for x in $subzone; do
  counter_mx=0
  for i in $mx_name; do
    if [[ $x == $i ]]; then
    sed -i "/MX_START/ a $x\t\t\tIN\tMX\t10 ${zoneip[$counter_mx]}" domain.zone.template
    fi
    let counter_mx+=1
  done
done

sed -i "/MX_START/d" domain.zone.template
sed -i "s/UNIQUE_ID/$( echo $( date +"%Y" ) )$( echo $RANDOM )/" domain.zone.template

mv domain.zone.template /etc/nsd/$domain.zone
mv domain.zone.template.bak domain.zone.template

zone_list2=( $( cat final_values ) )
counter_subzones=0
for x in $subzone; do
  cp domain.zone.template /etc/nsd/$x.zone
  sed -i "s/NS_RECORD_NAME/$rtrname\.$domain_name/" /etc/nsd/$x.zone
  sed -i "s/SOA_HEADER/$soa_head/" /etc/nsd/$x.zone
  sed -i "s/EMAIL_HEADER/$soa_email/" /etc/nsd/$x.zone
  sed -i "s/UNIQUE_ID/$( echo $( date +"%Y" ) )$( echo $RANDOM )/" /etc/nsd/$x.zone
  sed -i "/RECORDS_START/ a ${zone_list2[$counter_subzones]}\.\t\tIN\tPTR\t$x\.$domain" /etc/nsd/$x.zone
  sed -i "s/RECORDS_START//" /etc/nsd/$x.zone
  sed -i "/MX_START/d" /etc/nsd/$x.zone
  let counter_subzones+=1
done

rm -f final_values

echo -e " \e[32mnsd configurations complete!\e[39m"
