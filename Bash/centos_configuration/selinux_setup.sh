#!/bin/bash

# Change SELINUX from enforcing or permissive to disabled
echo " disabling selinux..."
sed -r -i 's/SELINUX=(enforcing|permissive)/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo -e " \e[32mselinux configuration complete!\e[39m"
