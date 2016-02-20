#!/bin/bash

ROOTDIR=~/src/cuckoo/conf
HOSTIP=$(/bin/hostname -I)

sed -i -e "s/ip = 192.168.56.1/ip = $HOSTIP/" $ROOTDIR/cuckoo.conf
