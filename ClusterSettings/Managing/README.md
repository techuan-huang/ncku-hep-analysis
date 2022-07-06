- The direcotry ./backup_tools contains the scripts for backing up users data to NAS (/mnt/data01)
- The directory ./root containts the scripts used for daily managing, for example, mounting NAS, power off compute nodes, and etc.

- To power up the whole cluster, please follow the steps:
  1. Plug in the UPSs
  2. Turn on the UPSs
  3. Power up the headnode
  4. Power up the NASs
  5. Logging headnode as root (with usual password)
  6. Turn on internal network connetion (eno1)
  7. Power up the compute nodes
  8. Mount the NAS

- To power off the cluster:
  1. Power off compute nodes
  2. Power off headnode
  3. Power off NASs
  4. Turn off the UPSs
  5. Unplug the UPSs
