#!/bin/bash

# Make sure everything is up to date
sudo apt-get update && sudo apt-get dist-upgrade

# General tools
sudo apt-get -y install vim git ctags vim-doc vim-scripts

# Tools for Cuckoo
sudo apt-get -y install python python-dev python-sqlalchemy python-bson \
    python-dpkt python-jinja2 python-magic python-pymongo python-gridfs \
    python-bottle python-pefile python-chardet libqt4-network \
    bridge-utils tcpdump libcap2-bin python-pip libqt4-opengl\
    libtool automake autoconf libfuzzy2 libfuzzy-dev libxml2 libxslt1-dev \
    postgresql-server-dev-9.4 curl libcurl4-gnutls-dev

# Install globaly
sudo pip install django maec \
    git+https://github.com/kbandla/pydeep#egg=pydeep

# Get volatility and cuckoo
if [ ! -d ~/src ]; then
    mkdir ~/src && cd ~/src
    git clone https://github.com/volatilityfoundation/volatility.git
    git clone https://github.com/cuckoobox/cuckoo.git
    wget -O ssdeep-2.13.tar.gz http://sourceforge.net/projects/ssdeep/files/ssdeep-2.13/ssdeep-2.13.tar.gz/download
    tar xvfz ssdeep-2.13.tar.gz
    wget -O virtualbox-4.3_4.3.28-100309~Debian~wheezy_amd64.deb \
        http://download.virtualbox.org/virtualbox/4.3.28/virtualbox-4.3_4.3.28-100309~Debian~wheezy_amd64.deb
    sudo dpkg --install virtualbox-4.3_4.3.28-100309~Debian~wheezy_amd64.deb
fi

# Setup for Cuckoo
if [ ! -d "/home/cuckoo" ]; then
    sudo adduser cuckoo
fi
sudo usermod -G vboxusers cuckoo
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

sudo apt-get -y install linux-headers-$(uname -r)
sudo /etc/init.d/vboxdrv setup
