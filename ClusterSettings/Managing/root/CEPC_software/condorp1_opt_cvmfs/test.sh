#!/bin/bash

wget http://cvmrepo.web.cern.ch/cvmrepo/yum/cernvm.repo -O /etc/yum.repos.d/cernvm.repo;
wget http://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM -O /etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM;
yum install cvmfs cvmfs-init-scripts cvmfs-auto-setup -y;
mv /etc/cvmfs /etc/cvmfs_bak
cp -r /opt/cvmfs/cvmfs /etc/cvmfs;
chown -R cvmfs.cvmfs /var/cache/cvmfs2;
service autofs stop;
service autofs start;
cvmfs_config probe;
cvmfs_talk cleanup 0;
chkconfig autofs on;
