#!/bin/bash

echo " installing postfix package..."
yum -y install postfix &> /dev/null

cp postfix_main.cf.template postfix_main.cf.template.bak

interfaces=$( cat main.conf | grep postfix_interfaces | sed 's/postfix_interfaces=//' )
mailbox=$( cat main.conf | grep postfix_mailbox | sed 's/postfix_mailbox=//' )
mailbox2=$( echo $mailbox | sed 's/\//\\\//' )

sed -i "s/MAILBOX/$mailbox2/" postfix_main.cf.template
sed -i "s/INTERFACES/$interfaces/" postfix_main.cf.template

rm -f /etc/postfix/main.cf
mv postfix_main.cf.template /etc/postfix/main.cf
mv postfix_main.cf.template.bak postfix_main.cf.template

echo -e " \e[32mpostfix configurations complete!\e[39m"
