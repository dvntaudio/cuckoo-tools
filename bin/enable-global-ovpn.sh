#!/bin/bash

set -e

sudo apt-get install -y openvpn

if [ ! -e /etc/openvpn/ovpn.se.cred ]; then
    if [[ $# -ne 1 ]]; then
        # Format shoud be password on the first line. 
        # Password on the second line"
        echo "Need file with username and password as argument."
        exit 1
    else
        sudo cp $1 /etc/openvpn/ovpn.se.cred
    fi
fi

CONFDIR=$(mktemp -d)
cd $CONFDIR
wget https://www.ovpn.se/download/configurations/unix/ovpn-se.zip
unzip ovpn-se.zip
cd OVPN*
sudo mv -f ovpn* /etc/openvpn
sudo chown -R root:root /etc/openvpn
rm -rf CONFDIR

ROOTCMD=$(mktemp)
echo "sed -i $'s/dev tun/auth-retry nointeract\\\ndev tun9\\\ndev-type tun/' /etc/openvpn/ovpn.conf" > $ROOTCMD
echo "sed -i 's!auth-user-pass!auth-user-pass /etc/openvpn/ovpn.se.cred!' /etc/openvpn/ovpn.conf" >> $ROOTCMD
echo "echo '' >> /etc/openvpn/ovpn.conf" >> $ROOTCMD
echo "echo route-nopull >> /etc/openvpn/ovpn.conf" >> $ROOTCMD
echo "echo 999  tun9 >> /etc/iproute2/rt_tables" >> $ROOTCMD
sudo bash $ROOTCMD
rm -f $ROOTCMD

#mv ~/src/cuckoo/conf/vpn.conf{,.off}
#[ ! -e ~/src/cuckoo/conf/vpn.conf.on ] && \
#    cp ~/cuckoo-tools/files/vpn.conf.on ~/src/cuckoo/conf/vpn.conf.on
#mv ~/src/cuckoo/conf/vpn.conf{.on,}

cd /etc/openvpn
sudo openvpn --config ovpn.conf --daemon

