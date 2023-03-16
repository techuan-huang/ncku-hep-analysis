#!/bin/bash

/sbin/iptables -t nat -A POSTROUTING -o eno2 -j MASQUERADE
/sbin/iptables -A FORWARD -i eno2 -o eno1 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i eno1 -o eno2 -j ACCEPT
