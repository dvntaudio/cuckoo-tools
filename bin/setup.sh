#!/bin/bash

# Make sure everything is up to date
sudo apt-get update && sudo apt-get dist-upgrade

# General tools
sudo apt-get -y install vim git ctags vim-doc vim-scripts

# Tools for Vmware
sudo apt-get -y install open-vm-tools-desktop fuse

# Tools for Cuckoo
sudo apt-get -y install python python-pip python-dev libffi-dev libssl-dev \
    mongodb qemu-kvm libvirt-bin bridge-utils yara python-yara libyara3 \
    libyara-dev python-libvirt tcpdump libcap2-bin virt-manager swig \
    suricata tesseract-ocr

# Configure suricata
if [ ! -e /etc/suricata/suricata.yaml ]; then
    sudo cp files/suricata.yaml /etc/suricata/suricata.yaml
    chown root:root /etc/suricata/suricata.yaml
    chmod 644 /etc/suricata/suricata.yaml
fi

# Install python packages globaly
sudo pip install django maec pycrypto ujson mitmproxy distorm3 pytz \
    m2crypto simplejson

# Get volatility and cuckoo
if [ ! -d ~/src ]; then
    mkdir ~/src && cd ~/src
    git clone https://github.com/volatilityfoundation/volatility.git
    cd volatility
    sudo python setup.py install
    cd ..
    git clone https://github.com/cuckoobox/cuckoo.git
    cd cuckoo
    sudo pip install -r requirements.txt
    ./utils/community.py -wafb 2.0
    cd
fi

#    wget -O ssdeep-2.13.tar.gz http://sourceforge.net/projects/ssdeep/files/ssdeep-2.13/ssdeep-2.13.tar.gz/download
#    tar xvfz ssdeep-2.13.tar.gz

#    git+https://github.com/kbandla/pydeep#egg=pydeep

# Setup for Cuckoo
if [ ! -d "/home/cuckoo" ]; then
    sudo adduser cuckoo
    sudo usermod -a -G libvirt cuckoo
fi

# Let the cuckoo user access tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

sudo apt-get -y install linux-headers-$(uname -r)
