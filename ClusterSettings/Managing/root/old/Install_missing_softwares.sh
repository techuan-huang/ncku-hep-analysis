#system default gcc and expat for GEANT4
rocks run host compute "yum install gcc-c++"
rocks run host compute "yum install expat-devel"

#ROOT dependencies
rocks run host compute "sh /mnt/data01/InstallRootDep.sh"

#newer gcc and python for ROOT6
#rocks run host compute "sh /mnt/data01/install-devtoolset-6.sh"
rocks run host compute "mkdir -vp /opt/rh/"
scp -r /opt/rh/* compute-0-0:/opt/rh/
scp -r /opt/rh/* compute-0-1:/opt/rh/
scp -r /opt/rh/* compute-0-2:/opt/rh/
scp -r /opt/rh/* compute-0-3:/opt/rh/
