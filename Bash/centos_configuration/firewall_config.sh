#Flush Table
iptables -F
iptables -X

# Default Policy
iptables -t filter -P INPUT INPUT_STATUS
iptables -t filter -P OUTPUT OUTPUT_STATUS
iptables -t filter -P FORWARD FORWARD_STATUS

# Allow Established Session
iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow Loopback Traffic
iptables -t filter -A INPUT -i lo -j ACCEPT

# Allow SSH Traffic
#SSH_SWITCH iptables -t filter -A INPUT -p TCP --dport 22 -j ACCEPT
#SSH_SWITCH iptables -t filter -A OUTPUT -p TCP --dport 22 -j ACCEPT
#SSH_SWITCH iptables -t filter -A FORWARD -p TCP --dport 22 -j ACCEPT

# Allow DNS Traffic
#DNS_SWITCH iptables -t filter -A INPUT -p UDP --dport 53 -j ACCEPT
#DNS_SWITCH iptables -t filter -A INPUT -p TCP --dport 53 -j ACCEPT
#DNS_SWITCH iptables -t filter -A OUTPUT -p UDP --dport 53 -j ACCEPT
#DNS_SWITCH iptables -t filter -A OUTPUT -p TCP --dport 53 -j ACCEPT
#DNS_SWITCH iptables -t filter -A FORWARD -p UDP --dport 53 -j ACCEPT
#DNS_SWITCH iptables -t filter -A FORWARD -p TCP --dport 53 -j ACCEPT

# Allow ICMP Traffic
#ICMP_SWITCH iptables -t filter -A INPUT -p ICMP -j ACCEPT
#ICMP_SWITCH iptables -t filter -A OUTPUT -p ICMP -j ACCEPT
#ICMP_SWITCH iptables -t filter -A FORWARD -p ICMP -j ACCEPT

# Allow ICMPv6 Traffic
#ICMP_SWITCH iptables -t filter -A INPUT -p ICMPv6 -j ACCEPT
#ICMP_SWITCH iptables -t filter -A OUTPUT -p ICMPv6 -j ACCEPT
#ICMP_SWITCH iptables -t filter -A FORWARD -p ICMPv6 -j ACCEPT

# Allow OSPF Traffic
#OSPF_SWITCH iptables -t filter -A INPUT -p OSPF -j ACCEPT
#OSPF_SWITCH iptables -t filter -A OUTPUT -p OSPF -j ACCEPT
#OSPF_SWITCH iptables -t filter -A FORWARD -p OSPF -j ACCEPT

# Allow Mail Traffic
#MAIL_SWITCH iptables -t filter -A INPUT -p TCP --dport 25 -j ACCEPT
#MAIL_SWITCH iptables -t filter -A INPUT -p UDP --dport 25 -j ACCEPT
#MAIL_SWITCH iptables -t filter -A OUTPUT -p TCP --dport 25 -j ACCEPT
#MAIL_SWITCH iptables -t filter -A OUTPUT -p UDP --dport 25 -j ACCEPT
#MAIL_SWITCH iptables -t filter -A FORWARD -p TCP --dport 25 -j ACCEPT
#MAIL_SWITCH iptables -t filter -A FORWARD -p UDP --dport 25 -j ACCEPT

# Dropped Packet Log
iptables -A INPUT -j LOG
iptables -A FORWARD -j LOG

#Log Save
sudo service iptables save &> /dev/null
