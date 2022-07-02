#!/bin/bash

#copy files
cd /mnt/data01/backup_upgrade/users
cat passwd.mig >> /etc/passwd
cat group.mig >> /etc/group
cat shadow.mig >> /etc/shadow
/bin/cp gshadow.mig /etc/gshadow

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
