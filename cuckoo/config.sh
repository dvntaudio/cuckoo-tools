#!/bin/bash

ROOTDIR=~/src/cuckoo/conf
HOSTIP=$(/bin/hostname -I)

sed -i -e "s/machinery = virtualbox/machinery = kvm" $ROOTDIR/cuckoo.conf
sed -i -e "s/ip = 192.168.56.1/ip = $HOSTIP/" $ROOTDIR/cuckoo.conf
sed -i -e "s/interface = vboxnet/interface = virbr0/" $ROOTDIR/auxiliary.conf
