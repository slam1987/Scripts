#!/bin/bash

# Stop and disable firewalld
echo " stopping and disabling firewalld..."
systemctl stop firewalld &> /dev/null
systemctl disable firewalld &> /dev/null

# Stop and disable NetworkManager
echo " stopping and disabling networkmanager..."
systemctl stop NetworkManager &> /dev/null
systemctl disable NetworkManager &> /dev/null

echo " enabling ip forwarding..."
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

# Configure network interfaces
echo " initializing network interface configurations..."
/bin/bash net_if_setup.sh
