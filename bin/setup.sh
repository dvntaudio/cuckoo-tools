#!/bin/bash

# Make sure everything is up to date
sudo apt-get update && sudo apt-get dist-upgrade

# General tools
sudo apt-get -y install vim git ctags vim-doc vim-scripts

# Tools for Vmware
sudo apt-get -y install open-vm-tools-desktop fuse

# Tools for Cuckoo
sudo apt-get -y install python python-pip python-dev libffi-dev libssl-dev \
    mongodb qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils \
    python-libvirt tcpdump libcap2-bin

# Get volatility and cuckoo
if [ ! -d ~/src ]; then
    mkdir ~/src && cd ~/src
    git clone https://github.com/volatilityfoundation/volatility.git
    git clone https://github.com/cuckoobox/cuckoo.git
fi

#    wget -O ssdeep-2.13.tar.gz http://sourceforge.net/projects/ssdeep/files/ssdeep-2.13/ssdeep-2.13.tar.gz/download
#    tar xvfz ssdeep-2.13.tar.gz

# Install globaly
#sudo pip install django maec \
#    git+https://github.com/kbandla/pydeep#egg=pydeep

# Setup for Cuckoo
if [ ! -d "/home/cuckoo" ]; then
    sudo adduser cuckoo
fi

# Let the cuckoo user access tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

sudo apt-get -y install linux-headers-$(uname -r)
