#!/bin/bash

echo "Syncing users to compute nodes ..."
wwsh file resync passwd shadow group
pdsh -w compute-0-[0-3] /warewulf/bin/wwgetfiles
echo ""
echo "Done! New user will be seen by compute nodes in few minutes!"

echo "Adding new users to PBS fairshare member ..."
# temporarily stop the scheduling
qmgr -c "set sched scheduling = False"

# add users to resource_group for fairshare usage
cp /var/spool/pbs/sched_priv/resource_group.bak /var/spool/pbs/sched_priv/resource_group
getent passwd | while IFS=: read -r name password uid gid gecos home shell;
do
    if [[ $home =~ ^/home/ ]]; then
        echo "$name 502 root 10" >> /var/spool/pbs/sched_priv/resource_group
    fi
done

# kill -HUP the scheduler to reload the configurations
kill -HUP $(pgrep -f pbs_sched)

# restart the scheduling
qmgr -c "set sched scheduling = True"

echo "Done! New user will be prioritized while scheduling!"
