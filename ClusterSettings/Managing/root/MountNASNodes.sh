#!/bin/bash

#mount NAS (data01) on headnode
mkdir -vp /mnt/data01
mount -t nfs -o rw 192.168.91.10:/volume1/data01 /mnt/data01

#mount NAS (data01) on compute nodes
pdsh -w compute-0-[0-3] "mkdir -vp /mnt/data01"
pdsh -w compute-0-0 "mount -t nfs -o rw 192.168.91.11:/volume1/data01 /mnt/data01"
pdsh -w compute-0-1 "mount -t nfs -o rw 192.168.91.12:/volume1/data01 /mnt/data01"
pdsh -w compute-0-2 "mount -t nfs -o rw 192.168.91.13:/volume1/data01 /mnt/data01"
pdsh -w compute-0-3 "mount -t nfs -o rw 192.168.91.11:/volume1/data01 /mnt/data01"
#pdsh -w compute-0-4 "mount -t nfs -o rw 192.168.91.12:/volume1/data01 /mnt/data01"
#pdsh -w compute-0-5 "mount -t nfs -o rw 192.168.91.13:/volume1/data01 /mnt/data01"
#pdsh -w compute-0-6 "mount -t nfs -o rw 192.168.91.11:/volume1/data01 /mnt/data01"
#pdsh -w compute-0-7 "mount -t nfs -o rw 192.168.91.12:/volume1/data01 /mnt/data01"
#pdsh -w compute-0-8 "mount -t nfs -o rw 192.168.91.13:/volume1/data01 /mnt/data01"
#pdsh -w compute-0-9 "mount -t nfs -o rw 192.168.91.11:/volume1/data01 /mnt/data01"

#mount NAS (data02) on headnode
mkdir -vp /mnt/data02
mount -t nfs -o rw 192.168.91.14:/volume1/data02 /mnt/data02

#mount NAS (data02) on compute nodes
pdsh -w compute-0-[0-3] "mkdir -vp /mnt/data02"
pdsh -w compute-0-0 "mount -t nfs -o rw 192.168.91.15:/volume1/data02 /mnt/data02"
pdsh -w compute-0-1 "mount -t nfs -o rw 192.168.91.16:/volume1/data02 /mnt/data02"
pdsh -w compute-0-2 "mount -t nfs -o rw 192.168.91.17:/volume1/data02 /mnt/data02"
pdsh -w compute-0-3 "mount -t nfs -o rw 192.168.91.15:/volume1/data02 /mnt/data02"
#pdsh -w compute-0-4 "mount -t nfs -o rw 192.168.91.16:/volume1/data02 /mnt/data02"
#pdsh -w compute-0-5 "mount -t nfs -o rw 192.168.91.17:/volume1/data02 /mnt/data02"
#pdsh -w compute-0-6 "mount -t nfs -o rw 192.168.91.15:/volume1/data02 /mnt/data02"
#pdsh -w compute-0-7 "mount -t nfs -o rw 192.168.91.16:/volume1/data02 /mnt/data02"
#pdsh -w compute-0-8 "mount -t nfs -o rw 192.168.91.17:/volume1/data02 /mnt/data02"
#pdsh -w compute-0-9 "mount -t nfs -o rw 192.168.91.15:/volume1/data02 /mnt/data02"

#mount NAS (data03) on headnode
mkdir -vp /mnt/data03
mount -t nfs -o rw 192.168.91.18:/volume1/data03 /mnt/data03

#mount NAS (data03) on compute nodes
pdsh -w compute-0-[0-3] "mkdir -vp /mnt/data03"
pdsh -w compute-0-0 "mount -t nfs -o rw 192.168.91.19:/volume1/data03 /mnt/data03"
pdsh -w compute-0-1 "mount -t nfs -o rw 192.168.91.20:/volume1/data03 /mnt/data03"
pdsh -w compute-0-2 "mount -t nfs -o rw 192.168.91.21:/volume1/data03 /mnt/data03"
pdsh -w compute-0-3 "mount -t nfs -o rw 192.168.91.19:/volume1/data03 /mnt/data03"
#pdsh -w compute-0-4 "mount -t nfs -o rw 192.168.91.20:/volume1/data03 /mnt/data03"
#pdsh -w compute-0-5 "mount -t nfs -o rw 192.168.91.21:/volume1/data03 /mnt/data03"
#pdsh -w compute-0-6 "mount -t nfs -o rw 192.168.91.19:/volume1/data03 /mnt/data03"
#pdsh -w compute-0-7 "mount -t nfs -o rw 192.168.91.20:/volume1/data03 /mnt/data03"
#pdsh -w compute-0-8 "mount -t nfs -o rw 192.168.91.21:/volume1/data03 /mnt/data03"
#pdsh -w compute-0-9 "mount -t nfs -o rw 192.168.91.19:/volume1/data03 /mnt/data03"

#mount NAS (data04) on headnode
mkdir -vp /mnt/data04
mount -t nfs -o rw 192.168.91.22:/volume1/data04 /mnt/data04

#mount NAS (data04) on compute nodes
pdsh -w compute-0-[0-3] "mkdir -vp /mnt/data04"
pdsh -w compute-0-0 "mount -t nfs -o rw 192.168.91.23:/volume1/data04 /mnt/data04"
pdsh -w compute-0-1 "mount -t nfs -o rw 192.168.91.24:/volume1/data04 /mnt/data04"
pdsh -w compute-0-2 "mount -t nfs -o rw 192.168.91.25:/volume1/data04 /mnt/data04"
pdsh -w compute-0-3 "mount -t nfs -o rw 192.168.91.23:/volume1/data04 /mnt/data04"
#pdsh -w compute-0-4 "mount -t nfs -o rw 192.168.91.24:/volume1/data04 /mnt/data04"
#pdsh -w compute-0-5 "mount -t nfs -o rw 192.168.91.25:/volume1/data04 /mnt/data04"
#pdsh -w compute-0-6 "mount -t nfs -o rw 192.168.91.23:/volume1/data04 /mnt/data04"
#pdsh -w compute-0-7 "mount -t nfs -o rw 192.168.91.24:/volume1/data04 /mnt/data04"
#pdsh -w compute-0-8 "mount -t nfs -o rw 192.168.91.25:/volume1/data04 /mnt/data04"
#pdsh -w compute-0-9 "mount -t nfs -o rw 192.168.91.23:/volume1/data04 /mnt/data04"
