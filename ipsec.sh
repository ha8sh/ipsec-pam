#!/bin/bash

wget https://github.com/ha8sh/ipsec-pam/blob/main/pam_radius_auth.so -O /opt/pam_radius_auth.so
rm /etc/pam.d/pluto

cat << EOF > /etc/pam.d/pluto
auth    required        /opt/pam_radius_auth.so
account required        /opt/pam_radius_auth.so
session required        /opt/pam_radius_auth.so

EOF

rm /etc/ipsec.secret
cat << EOF > /etc/ipsec.secret
%any  %any  : PSK "123456789"
EOF

sed '/^cisco-unity=.*/a xauthby=pam' /etc/ipsec.conf
sed '/^\s cisco-unity=.*/a \  xauthby=pam' /etc/ipsec.conf | tee /etc/ipsec.conf2
rm /etc/ipsec.conf
mv /etc/ipsec.conf2 /etc/ipsec.conf




mkdir -p /etc/raddb
touch /etc/raddb/server

systemctl restart xl2tpd
systemctl restart ipsec
