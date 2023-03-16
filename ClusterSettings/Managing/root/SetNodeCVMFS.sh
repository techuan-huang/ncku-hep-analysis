#!/bin/bash

# for headnode
cvmfs_config setup
systemctl restart autofs
cvmfs_config probe

# for compute nodes
pdsh -w compute-0-[0-3] "cvmfs_config setup"
pdsh -w compute-0-[0-3] "systemctl restart autofs"
pdsh -w compute-0-[0-3] "cvmfs_config probe"
