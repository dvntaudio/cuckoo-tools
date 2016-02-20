#!/bin/bash

ROOTDIR=~/src/cuckoo/conf
HOSTIP=$(/bin/hostname -I)


sed -i -e "s/machinery = virtualbox/machinery = kvm/" $ROOTDIR/cuckoo.conf
sed -i -e "s/ip = 192.168.56.1/ip = $HOSTIP/" $ROOTDIR/cuckoo.conf
sed -i -e "s/upload_max_size = 10465760/upload_max_size = 52428800/" $ROOTDIR/cuckoo.conf
