#!/bin/bash

ROOTDIR=~/src/cuckoo/conf
HOSTIP=$(/bin/hostname -I)

cp ~/cuckoo-tools/files/*.conf $ROOTDIR
sed -i -e "s/ip = 192.168.56.1/ip = $HOSTIP/" $ROOTDIR/cuckoo.conf

sudo cp ~/cuckoo-tools/files/suricata.yaml /etc/suricata

mitmproxy > /dev/null 2>&1 & 

MITM_PID=$!

sleep 10

kill -9 $MITM_PID

cp ~/.mitmproxy/mitmproxy-ca-cert.p12 ~/src/cuckoo/analyzer/windows/bin/cert.p12
