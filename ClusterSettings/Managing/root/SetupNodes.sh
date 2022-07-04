#!/bin/bash

#######################################
### Input Variables
#######################################

#headnode
sms_name="dirac"
sms_ip="192.168.91.1"
sms_eth_internal="eno1"

eth_provision="eno1"
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

#export CHROOT=/opt/ohpc/admin/images/rocky8.6

# Add NFS client mounts of /home and /opt/ohpc/pub to base image
#echo "${sms_ip}:/home /home nfs nfsvers=3,nodev,nosuid 0 0" >> $CHROOT/etc/fstab
#echo "${sms_ip}:/opt/ohpc/pub /opt/ohpc/pub nfs nfsvers=3,nodev 0 0" >> $CHROOT/etc/fstab

#Assemble Virtual Node File System (VNFS) image
#wwvnfs --chroot $CHROOT

# Set provisioning interface as the default networking device
#echo "GATEWAYDEV=${eth_provision}" > /tmp/network.$$
#wwsh -y file import /tmp/network.$$ --name network
#wwsh -y file set network --path /etc/sysconfig/network --mode=0644 --uid=0
# Add nodes to Warewulf data store
#for ((i=0; i<$num_computes; i++)) ; do
#    wwsh -y node new ${c_name[i]} --ipaddr=${c_ip[i]} --hwaddr=${c_mac[i]} -D ${eth_provision}
#done

# Define provisioning image for hosts
wwsh -y provision set "${compute_regex}" --vnfs=rocky8.6 --bootstrap=`uname -r` \
--files=dynamic_hosts,passwd,group,shadow,network

# Restart dhcp / update PXE
systemctl restart dhcpd
wwsh pxe update
