listinterface=$( sed -e '1,/NETWORK_CONFIGURATION_START/d' main.conf | sed -e '/NETWORK_CONFIGURATION_END/,$d' | grep { | sed 's/{//g' )

var=0

for x in $listinterface
do
  echo $var
  let var+=1
done
