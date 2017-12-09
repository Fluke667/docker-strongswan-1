#!/bin/bash

sysctl -w net.ipv4.conf.all.rp_filter=2

iptables --table nat --append POSTROUTING --jump MASQUERADE
echo 1 > /proc/sys/net/ipv4/ip_forward
for each in /proc/sys/net/ipv4/conf/*
do
	echo 0 > $each/accept_redirects
	echo 0 > $each/send_redirects
done

if [ -f "/etc/ipsec.d/ipsec.secrets" ]; then
	echo "Overwriting standard /etc/ipsec.secrets with /etc/ipsec.d/ipsec.secrets"
	cp -f /etc/ipsec.d/ipsec.secrets /etc/ipsec.secrets
fi

if [ -f "/etc/ipsec.d/ipsec.conf" ]; then
	echo "Overwriting standard /etc/ipsec.conf with /etc/ipsec.d/ipsec.conf"
	cp -f /etc/ipsec.d/ipsec.conf /etc/ipsec.conf
fi

if [ -f "/etc/ipsec.d/strongswan.conf" ]; then
	echo "Overwriting standard /etc/strongswan.conf with /etc/ipsec.d/strongswan.conf"
	cp -f /etc/ipsec.d/strongswan.conf /etc/strongswan.conf
fi

exec /usr/bin/supervisord -c /supervisord.conf
