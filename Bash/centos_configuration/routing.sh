#!/bin/bash

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo " restarting network service..."
systemctl restart network
