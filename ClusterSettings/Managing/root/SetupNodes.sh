#!/bin/bash

#######################################
### Input Variables
#######################################

#headnode
sms_name="dirac"
sms_ip="192.168.91.1"
sms_eth_internal="eno1"

eth_provision="eth0"
internal_netmask="255.255.255.0"
ntp_server="pool.ntp.org"
bmc_username=""
bmc_password=""

#compute node
num_computes=4
c_ip=( "192.168.91.251" "192.168.91.252" "192.168.91.253" "192.168.91.254" )
c_bmc=( "" "" "" "" )
c_mac=( "A4:BF:01:3E:2F:5F" "A4:BF:01:0D:80:0B" "A4:BF:01:13:F7:B2" "A4:BF:01:55:CF:E9")
c_name=( "compute-0-0" "compute-0-1" "compute-0-2" "compute-0-3" )

compute_regex="compute-0-*"
compute_prefix="compute-0-"

#######################################
### Provisioning
#######################################

# Enable internal interface for provisioning
ip link set dev ${sms_eth_internal} up
ip address add ${sms_ip}/${internal_netmask} broadcast + dev ${sms_eth_internal}

# Restart/enable relevant services to support provisioning
systemctl enable httpd.service
systemctl restart httpd
systemctl enable dhcpd.service
systemctl enable tftp.socket
systemctl start tftp.socket

export CHROOT=/opt/ohpc/admin/images/rocky8.6

# Define provisioning image for hosts
wwsh -y provision set "${compute_regex}" --vnfs=rocky8.6 --bootstrap=`uname -r` --files=dynamic_hosts,passwd,group,shadow,network

wwsh -y provision set --filesystem=gpt "${compute_regex}"
wwsh -y provision set --bootloader=sda "${compute_regex}"

# Restart dhcp / update PXE
systemctl restart dhcpd
wwsh pxe update
