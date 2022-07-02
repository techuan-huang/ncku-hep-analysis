#!/bin/sh

yum install scl-utils

rpm -ivh "https://www.softwarecollections.org/repos/rhscl/devtoolset-3/epel-6-x86_64/noarch/rhscl-devtoolset-3-epel-6-x86_64-1-2.noarch.rpm"
yum install devtoolset-3-gcc devtoolset-3-gcc-c++ devtoolset-3-gdb devtoolset-3-gcc-gfortran

yum install centos-release-scl
yum install python27
