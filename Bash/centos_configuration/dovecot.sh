#!/bin/bash

echo " installing dovecot package..."
yum -y install dovecot &> /dev/null

mailbox=$( cat main.conf | grep postfix_mailbox | sed 's/postfix_mailbox=//' )
mailbox2=$( echo $mailbox | sed 's/\//\\\//' )

cp 10-mail.conf.template 10-mail.conf.template.bak
cp 10-auth.conf.template 10-auth.conf.template.bak

sed -i "s/DIRECTORY/$mailbox2/" 10-mail.conf.template
rm -f /etc/dovecot/conf.d/10-mail.conf
rm -f /etc/dovecot/conf.d/10-auth.conf
mv 10-mail.conf.template /etc/dovecot/conf.d/10-mail.conf
mv 10-auth.conf.template /etc/dovecot/conf.d/10-auth.conf
mv 10-mail.conf.template.bak 10-mail.conf.template
mv 10-auth.conf.template.bak 10-auth.conf.template

echo -e " \e[32mdovecot configurations complete!\e[39m"
