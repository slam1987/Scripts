#!/bin/bash

echo " updating packages list..."
yum -y update &> /dev/null
yum -y group install base &> /dev/null
echo " installing epel release..."
yum -y install epel-release &> /dev/null
yum -y update &> /dev/null
echo " installing misc packages..."
yum -y install curl vim wget tmux nmap-ncat tcpdump nmap tmux net-tools telnet &> /dev/null
echo " installing kernel headers..."
yum -y install kernel-devel kernel-headers dkms gcc gcc-c+ &> /dev/null

echo -e " \e[32mbase configurations complete!\e[39m"
