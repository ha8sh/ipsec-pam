#!/bin/bash

wget https://github.com/ha8sh/ipsec-pam/blob/main/pam_radius_auth.so -O /opt/pam_radius_auth.so
rm /etc/pam.d/pluto

cat << EOF > /etc/pam.d/pluto
auth    required        /opt/pam_radius_auth.so
account required        /opt/pam_radius_auth.so
session required        /opt/pam_radius_auth.so

EOF

mkdir /etc/raddb
touch /etc/raddb/server
