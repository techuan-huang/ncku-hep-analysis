#!/bin/bash

#remove the old backups
cd /mnt/data01/backup_upgrade
rm -rf ./users/*

#backup the users settings
cd /mnt/data01/backup_upgrade/users
export UGIDLIMIT=500
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd > ./passwd.mig
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/group > ./group.mig
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - |egrep -f - /etc/shadow > ./shadow.mig
cp /etc/gshadow ./gshadow.mig

#backup the home directories and software
cd /mnt/data01/backup_upgrade/users_backup

rm -rf mail.tar.gz
tar -zcvpf mail.tar.gz /var/spool/mail

rsync -avh --delete /home/ ./home
rsync -avh --delete /root/ ./root

echo "+++++++++++++++++++++++++++"
echo "Backup process completed!"
echo "+++++++++++++++++++++++++++"
