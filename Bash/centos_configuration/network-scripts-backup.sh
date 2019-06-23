#!/bin/bash

var=$( ls /etc/sysconfig/network-scripts/ )

for x in $var
do
  echo cp $x $x'.bak'
done
