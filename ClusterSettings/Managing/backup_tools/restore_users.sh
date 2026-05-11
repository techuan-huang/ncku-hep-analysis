#!/bin/bash

#copy files
cd /mnt/data04/backup_userdata/users
cat passwd.mig >> /etc/passwd
cat group.mig >> /etc/group
cat shadow.mig >> /etc/shadow
/bin/cp gshadow.mig /etc/gshadow

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
