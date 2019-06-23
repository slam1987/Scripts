#!/bin/bash

# Variables
access_key=$( cat ../secrets/credentials.ini | grep aws_access_key_id | sed 's/aws_access_key_id=//' )
secret_key=$( cat ../secrets/credentials.ini | grep aws_secret_access | sed 's/aws_secret_access_key=//' )
session_token=$( cat ../secrets/credentials.ini | grep aws_session_token | sed 's/aws_session_token=//' )
file=$( echo ./group_vars/all )
converted_key=$( cat ../secrets/credentials.ini | grep aws_session_token | sed 's/aws_session_token/aws_security_token/' )

# Flush Previous Entries
sed -i "/aws_access_key/d" $file
sed -i "/aws_secret_key/d" $file
sed -i "/aws_session_token/d" $file
sed -i "/^  /d" $file

# Encrypt
enc_access_key=$( ansible-vault encrypt_string --encrypt-vault-id default --vault-password-file=.vault_password $access_key --name 'aws_access_key' >> $file )
enc_secret_key=$( ansible-vault encrypt_string --encrypt-vault-id default --vault-password-file=.vault_password $secret_key --name 'aws_secret_key' >> $file )
enc_session_token=$( ansible-vault encrypt_string --encrypt-vault-id default --vault-password-file=.vault_password $session_token --name 'aws_session_token' >> $file )

# Add Converted Session Key
sed -i "/aws_session_token/ a $converted_key" ../secrets/credentials.ini


echo 'Successfully changed Ansible AWS credentials!'
