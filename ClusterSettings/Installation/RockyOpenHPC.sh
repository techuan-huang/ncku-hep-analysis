#!/bin/bash

echo "This script is just for reference. Not run it directly!!"
exit

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
### Setup on headnode (note: with root permission)
#######################################

#hosts
echo ${sms_ip} ${sms_name} >> /etc/hosts

#disable SELinux
#$vi /etc/selinux/config
#$SELINUX=disabled

#disable firewall
systemctl disable firewalld
systemctl stop firewalld

#enable OpenHPC repository
yum install http://repos.openhpc.community/OpenHPC/2/EL_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm

#enable EPEL repository
yum install dnf-plugins-core
yum config-manager --set-enabled powertools

# Install base meta-packages
yum -y install ohpc-base
yum -y install ohpc-warewulf

#setup synchronized clocks
systemctl enable chronyd.service
echo "local stratum 10" >> /etc/chrony.conf
echo "server ${ntp_server}" >> /etc/chrony.conf
echo "allow all" >> /etc/chrony.conf
systemctl restart chronyd

#add resource management services
yum -y install openpbs-server-ohpc

# Configure Warewulf provisioning to use desired internal interface
perl -pi -e "s/device = eth1/device = ${sms_eth_internal}/" /etc/warewulf/provision.conf
# Enable internal interface for provisioning
ip link set dev ${sms_eth_internal} up
ip address add ${sms_ip}/${internal_netmask} broadcast + dev ${sms_eth_internal}
# Restart/enable relevant services to support provisioning
systemctl enable httpd.service
systemctl restart httpd
systemctl enable dhcpd.service
systemctl enable tftp.socket
systemctl start tftp.socket

#######################################
### Define compute image for provisioning
#######################################

# Define chroot location
export CHROOT=/opt/ohpc/admin/images/rocky8.6
# Build initial chroot image
wwmkchroot -v rocky-8 $CHROOT
# Enable OpenHPC and EPEL repos inside chroot
dnf -y --installroot $CHROOT install epel-release
cp -p /etc/yum.repos.d/OpenHPC*.repo $CHROOT/etc/yum.repos.d

# Install compute node base meta-package
yum -y --installroot=$CHROOT install ohpc-base-compute

cp -p /etc/resolv.conf $CHROOT/etc/resolv.conf

# Add OpenPBS client support
yum -y --installroot=$CHROOT install openpbs-execution-ohpc
perl -pi -e "s/PBS_SERVER=\S+/PBS_SERVER=${sms_name}/" $CHROOT/etc/pbs.conf
echo "PBS_LEAF_NAME=${sms_name}" >> /etc/pbs.conf
chroot $CHROOT opt/pbs/libexec/pbs_habitat
perl -pi -e "s/\$clienthost \S+/\$clienthost ${sms_name}/" $CHROOT/var/spool/pbs/mom_priv/config
echo "\$usecp *:/home /home" >> $CHROOT/var/spool/pbs/mom_priv/config
chroot $CHROOT systemctl enable pbs
# Add Network Time Protocol (NTP) support
yum -y --installroot=$CHROOT install chrony
# Identify master host as local NTP server
echo "server ${sms_ip} iburst" >> $CHROOT/etc/chrony.conf
# Add kernel drivers (matching kernel version on SMS node)
yum -y --installroot=$CHROOT install kernel-`uname -r`
# Include modules user environment
yum -y --installroot=$CHROOT install lmod-ohpc


# Initialize warewulf database and ssh_keys
wwinit database
wwinit ssh_keys
# Add NFS client mounts of /home and /opt/ohpc/pub to base image
echo "${sms_ip}:/home /home nfs nfsvers=3,nodev,nosuid 0 0" >> $CHROOT/etc/fstab
echo "${sms_ip}:/opt/ohpc/pub /opt/ohpc/pub nfs nfsvers=3,nodev 0 0" >> $CHROOT/etc/fstab
# Export /home and OpenHPC public packages from master server
echo "/home *(rw,no_subtree_check,fsid=10,no_root_squash)" >> /etc/exports
echo "/opt/ohpc/pub *(ro,no_subtree_check,fsid=11)" >> /etc/exports

# Finalize NFS config and restart
exportfs -a
systemctl restart nfs-server
systemctl enable nfs-server


#######################################
### Import files
#######################################

wwsh file import /etc/passwd
wwsh file import /etc/group
wwsh file import /etc/shadow

#######################################
### Finalize
#######################################

#vi /etc/warewulf/vnfs.conf
#hybridize += /usr/include  #comment out this line

#disable SELinux on nodes
#$vi $CHROOT/etc/selinux/config
#$SELINUX=disabled

# (Optional) Include drivers from kernel updates; needed if enabling additional kernel modules on computes
export WW_CONF=/etc/warewulf/bootstrap.conf
echo "drivers += updates/kernel/" >> $WW_CONF
# Build bootstrap image
wwbootstrap `uname -r`

# Add GRUB2 bootloader and re-assemble VNFS image (for nodes to boot from local disk)
yum -y --installroot=$CHROOT install grub2

#Assemble Virtual Node File System (VNFS) image
wwvnfs --chroot $CHROOT

# Set provisioning interface as the default networking device
echo "GATEWAYDEV=${eth_provision}" > /tmp/network.$$
wwsh -y file import /tmp/network.$$ --name network
wwsh -y file set network --path /etc/sysconfig/network --mode=0644 --uid=0
# Add nodes to Warewulf data store
for ((i=0; i<$num_computes; i++)) ; do
    wwsh -y node new ${c_name[i]} --ipaddr=${c_ip[i]} --hwaddr=${c_mac[i]} -D ${eth_provision}
done

# Define provisioning image for hosts
wwsh -y provision set "${compute_regex}" --vnfs=rocky8.6 --bootstrap=`uname -r` \
--files=dynamic_hosts,passwd,group,shadow,network

# Select (and customize) appropriate parted layout example
cp /etc/warewulf/filesystem/examples/gpt_example.cmds /etc/warewulf/filesystem/gpt.cmds
wwsh provision set --filesystem=gpt "${compute_regex}"
wwsh provision set --bootloader=sda "${compute_regex}"

# Configure local boot (after successful provisioning) (not tested yet)
#wwsh provision set --bootlocal=normal "${compute_regex}"


# Restart dhcp / update PXE
systemctl restart dhcpd
wwsh pxe update

#######################################
### Install OpenHPC Development Components
#######################################

# Install autotools meta-package
yum -y install ohpc-autotools
yum -y install EasyBuild-ohpc
yum -y install hwloc-ohpc
yum -y install spack-ohpc
yum -y install valgrind-ohpc

# MPI Stacks
yum -y install openmpi4-gnu9-ohpc mpich-ofi-gnu9-ohpc
yum -y install mpich-ucx-gnu9-ohpc

# Install perf-tools meta-package
yum -y install ohpc-gnu9-perf-tools

# Setup default development environment
yum -y install lmod-defaults-gnu9-openmpi4-ohpc

# Install 3rd party libraries/tools meta-packages built with GNU toolchain
yum -y install ohpc-gnu9-serial-libs
yum -y install ohpc-gnu9-io-libs
yum -y install ohpc-gnu9-python-libs
yum -y install ohpc-gnu9-runtimes

# Install parallel lib meta-packages for all available MPI toolchains
yum -y install ohpc-gnu9-mpich-parallel-libs
yum -y install ohpc-gnu9-openmpi4-parallel-libs

#######################################
### Resource Manager Startup
#######################################

# start PBS daemons on master host
systemctl enable pbs
systemctl start pbs

# initialize PBS path
. /etc/profile.d/pbs.sh
# enable user environment propagation (needed for modules support)
qmgr -c "set server default_qsub_arguments= -V"
# enable uniform multi-node MPI task distribution
qmgr -c "set server resources_default.place=scatter"
# enable support for job accounting
qmgr -c "set server job_history_enable=True"
# register compute hosts with PBS
for host in "${c_name[@]}"; do
    qmgr -c "create node $host"
done

#######################################
### Resource Manager Startup
#######################################

#distribute jobs evenly to compute nodes and start jobs according to job priority
vim /var/spool/pbs/sched_priv/sched_config
job_sort_key: "fairshare_tree_usage LOW"        ALL
node_sort_key: "ncpus HIGH"     ALL

vim /opt/pbs/etc/pbs_sched_config
job_sort_key: "fairshare_tree_usage LOW"        ALL
node_sort_key: "ncpus HIGH"     ALL
