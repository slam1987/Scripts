# Linux CentOS Configuration Script
**By: Stanley Lam - 2018**

This script is able to configure a minimal CentOS Linux server installation to a router/server using a centralized configuration file.

Services include: DHCP (dhcpd), DNS (nsd), DNS caching (unbound), firewall (iptables), OSPF (ospfd), wireless AP, IMAP (dovecot), STMP (postfix). *email protocols encryption not included

**NOTE:** This project was the second semester final project at BCIT. There are definitely easier ways to do this such as using Ansible, however, doing it from scratch was a great learning experience overall.


**HOW TO USE:**

`main.conf` is the main configuration and switchboard file for this script.

**Wired network interface configuration:**
Set the ip address for each interface by inputting the ip address and prefix separated by a comma for `netconf_ip_address`.
The interfaces will be named starting from eth0 and is determined by the sequence in which the addresses are entered.
The default gateway should be set for `netconf_default_gateway` and will be automatically addressed to eth0.

**Wireless network interface configuration:**
Set the ip address for each wireless interface by inputting the ip address and prefix separated by a comma for `wificonf_ip_address`.
The interfaces will be named according to the output from the command `iw dev`.
The setting for the wireless channel on 2.4G network will be set using `wificonf_channel` which will determine the channel used for all wifi access points.
The wireless access point password is set using `hostapd_password`. Separate password can be used which are separated by a comma.

**NSD configuration:**
`nsd_bind_ip` should be set using the ip address of the interface in which it will run on.
`nsd_domain_name` should be set as the full domain name.
`nsd_soa_email` is the contact email for the administrator.
`nsd_router_a_name` is the A record of the router name.
`nsd_zones_name` are the names of each zone in the domain which should include the router name. This support multiple entries separated by commas.
`nsd_zones_ip` is the ip addresses without prefix entered in sequence according to the `nsd_zones_name`.
`nsd_mx_records` are the mx records which can support multiple entries separated by commas.

**Unbound configuration:**
`unbound_bind_ip` should be set using the ip address of the intferface in which it will run on. Make sure this is not the same ip address used by NSD. 
`unbound_port` should be set for 53 as default for DNS.
`unbound_access_allow` is the ip networks which unbound allows requests from. Entries must include ip address and prefix. This supports multiple entries separated by commas. To enable all interfaces use 0.0.0.0/0.
`unbound_access_deny` is the ip networks which unbound refuses requests from. Entried must include ip address and prefix. This supports multiple entried separated by commas.
`unbound_private_domain_ip` should be set as the ip address and prefix to where DNS requests should be sent. Recommended to set as the `nsd_bind_ip` address.
`unbound_stub_zones` are the zone names that should be processed by the ip addresses listed in `unbound_stub_ip`. Support multiple entries separated by commas.
`unbound_stub_ip are` the ip addresses and prefix for `unbound_stub_zones`. Support multiple entries separated by commas.

**DHCP configuration:**
`dhcp_networks` are the ip address and prefix that provide DHCP services. Supports multiple entries separated by commas.
`dhcp_ip_range` are the ip address scopes from min-max format. Supports multiple entries separated by commas relative to `dhcp_networks`.
`dhcp_reservation_mac` is the mac address entry for ip reservations. Supports multiple entries separated by commas.
`dhcp_reservation_ip` is the ip address for dhcp_reservation_mac. Supports multiple entries separated by commas relative to `dhcp_reservation_mac`.

**Postfix configuration:**
`postfix_interfaces` should be set to "all".
`postfix_mailbox` is the directory to store the mail.

**Firewall configuration:**
`firewall_default_input` sets the default policy for incoming traffic. Options are "DROP" or "ACCEPT".
`firewall_allow_dns` is the switch enables DNS traffic through the firewall. Options are "true" or "false". *DNS will not work if this option is set to false.
`firewall_allow_icmp` is the switch enables ICMP traffic through the firewall. Options are "true" or "false". PING will not work if this option is set to false.
`firewall_ospf` is the switch enables multicast traffic for OSPF through the firewall. Options are "true" or "false". Rotuing protocol OSPF will not work if this option is set to false.
`firewall_allow_ssh` is the switch enables ssh traffic through the firewall. Options are "true" or "false". SSH will not work if this option is set to false.
The firewall switches are designed to affect all interfaces which includes input, output, and forwarding. This does not include the ability to select individual interfaces or addresses.

