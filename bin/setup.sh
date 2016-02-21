#!/bin/bash

# Make sure everything is up to date
sudo apt-get update && sudo apt-get dist-upgrade

# General tools
sudo apt-get -y -qq install vim git ctags vim-doc vim-scripts

# Tools for Vmware
sudo apt-get -y -qq install open-vm-tools-desktop fuse

# Tools for Cuckoo
sudo apt-get -y -qq install python python-pip python-dev libffi-dev libssl-dev \
    mongodb qemu-kvm libvirt-bin bridge-utils yara python-yara libyara3 \
    libyara-dev python-libvirt tcpdump libcap2-bin virt-manager swig \
    suricata tesseract-ocr libjpeg-dev linux-headers-$(uname -r)

# Configure suricata
if [ ! -e /etc/suricata/suricata.yaml ]; then
    sudo cp files/suricata.yaml /etc/suricata/suricata.yaml
    sudo chown root:root /etc/suricata/suricata.yaml
    sudo chmod 644 /etc/suricata/suricata.yaml
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

# Setup for Cuckoo
if [ ! -d "/home/cuckoo" ]; then
    sudo adduser cuckoo
    sudo usermod -a -G libvirt cuckoo
fi

# Let the cuckoo user access tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

