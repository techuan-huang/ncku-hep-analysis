## backup tools
- The direcotry ./backup_tools contains the scripts for backing up users data to NAS (/mnt/data01)
- The directory ./root containts the scripts used for daily managing, for example, mounting NAS, power off compute nodes, and etc.

## How to turn on/off the cluster
- To power up the whole cluster, please follow the steps:
  1. Plug in the UPSs
  2. Turn on the UPSs
  3. Power on the headnode
  4. Power on the NASs
  5. Log in headnode as root (with usual password)
  6. Excute "source SetupNodes.sh" in terminal
  7. Power on the compute nodes (~15 min)
  8. Mount the NAS (excute "./MountNASNodes.sh")
  9. Setup CVMFS for compute nodes (excute "./SetNodeCVMFS.sh")
  10. Log out from headnode

- To power off the cluster:
  1. Log in headnode as root (with usual password)
  2. Power off compute nodes (excute "./PowerOff_all.sh")
  3. Power off headnode
  4. Power off NASs
  5. Turn off the UPSs
  6. Unplug the UPSs

## How to add a new user to cluster
- If you want to add a new user to cluster, run following commands:
```sh
useradd -m <new user>
./ResyncUsers.sh
```
The new user will be synced to compute nodes in 5 minutes.

## Full disk due to OpenPBS log files
OpenPBS is the package we used to manage batch jobs on our cluster. It records its logs at ```/var/spool/pbs/sched_logs``` everyday. However, we only assigned 70GB to ```/```. Once it is full, you may see compute nodes keep rebooting when you turn them on. You may also experience some command, like ```yum update``` stuck. So, it's better to clean up this space regularly.

## Installing YUM/DNF packages for compute nodes
- Path to the Virtual Node File System (VNFS)
```sh
export CHROOT=/opt/ohpc/admin/images/rocky8.6
```

- Install the package to the VNFS path
```sh
yum -y --installroot=$CHROOT install <package>
```

- Re-build the VNFS image for compute nodes (It may take 20-25 minutes).
```sh
wwvnfs --chroot $CHROOT
```

- Start the VNFS provisioning
```sh
source SetupNodes.sh
```

- After this is done, reboot all the compute nodes.

## Update YUM/DNF packages
#### For headnode, it's simple:
- Update the package
```sh
yum -y update
```

#### For compute nodes
- Path to the Virtual Node File System (VNFS)
```sh
export CHROOT=/opt/ohpc/admin/images/rocky8.6
```

- Update the package to the VNFS path
```sh
yum -y --installroot=$CHROOT update
```

- Re-build the VNFS image for compute nodes (It may take 20-25 minutes).
```sh
wwvnfs --chroot $CHROOT
```

- If there was an update on kernel, you need to run following command. Otherwise, skip this step:
```sh
wwbootstrap `uname -r`
```

- Start the VNFS provisioning
```sh
source SetupNodes.sh
```

- After this is done, reboot all the compute nodes.
