#!/bin/bash

# Make sure everything is up to date
sudo apt-get update && sudo apt-get dist-upgrade

# General tools
sudo apt-get install vim git ctags vim-doc vim-scripts

# Tools for Cuckoo
sudo apt-get install python python-sqlalchemy python-bson python-dpkt \
    python-jinja2 python-magic python-pymongo python-gridfs python-libvirt \
    python-bottle python-pefile python-chardet qemu-kvm libvirt-bin \
    bridge-utils tcpdump libcap2-bin python-pip virt-manager libtool automake \
    autoconf libfuzzy2 libfuzzy-dev libxml2 libxslt1-dev \
    postgresql-server-dev-9.1 curl libcurl4-gnutls-dev

# Install globaly
sudo pip install django pydepp pyfuzzy maec

# Get volatility and cuckoo
if [ ! -d "~/src" ]; then
    mkdir ~/src && cd ~/src
    git clone https://github.com/volatilityfoundation/volatility.git
    git clone https://github.com/cuckoobox/cuckoo.git
    wget -O ssdeep-2.13.tar.gz http://sourceforge.net/projects/ssdeep/files/ssdeep-2.13/ssdeep-2.13.tar.gz/download
    tar xvfz ssdeep-2.13.tar.gz
fi

# Setup for Cuckoo
sudo adduser cuckoo
sudo usermod -G libvirt cuckoo
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump
