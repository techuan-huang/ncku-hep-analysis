#!/bin/bash

#backups
mkdir /root/newsusers.bak
cp /etc/passwd /etc/shadow /etc/group /etc/gshadow /root/newsusers.bak
cp /etc/exports /etc/exports.bk
cp /etc/auto.home /etc/auto.home.bk

#copy files
cd /mnt/data04/backup_userdata/users
cat passwd.mig >> /etc/passwd
cat group.mig >> /etc/group
cat shadow.mig >> /etc/shadow
/bin/cp gshadow.mig /etc/gshadow

#restore the home directories and software
cd /mnt/data04/backup_userdata/users_backup
rsync -avzhP ./home/ /home
#rsync -avzhP ./root/ /root  #Don't use this line. It will cause problems.
#cp -r CEPC_software fit_example.txt gridengine_bk InstallGcc482_nodes.sh installGCC.sh InstallRootDep.sh log mk_PKworkdir.sh MountNASNodes.sh newsusers.bak PowerOff_all.sh ReinstallAllNodes.sh rh-cve-2016-5195_3.sh .mozilla /root
tar -zxvf mail.tar.gz /

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Restore process completed."
echo "Don't forget to check the permittions of users' \$HOME directory."
echo "Please reboot to activate the changes!"
echo "Please contact Te-Chuan if you meet any problem. (Te-Chuan Huang tchuang@phys.ncku.edu.tw)"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
