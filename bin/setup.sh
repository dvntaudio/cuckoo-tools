#!/bin/bash

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

if [ ! -d ~/src ]; then
    mkdir ~/src
fi    

# Install ssdeep for pydeep
if [ ! -d ~/src/ssdeep-2.13 ]; then
    cd ~/src
    wget http://sourceforge.net/projects/ssdeep/files/ssdeep-2.13/ssdeep-2.13.tar.gz/download -O ssdeep-2.13.tar.gz
    tar xvfz ssdeep-2.13.tar.gz
    cd ssdeep-2.13/
    ./configure
    make
    sudo make install
    cd
fi

# Install python packages globaly
sudo pip install django maec pycrypto ujson mitmproxy distorm3 pytz \
    m2crypto simplejson pydeep python-pil

# Install volatility
if [ ! -d ~/src/volatility ]; then
    cd ~/src
    git clone https://github.com/volatilityfoundation/volatility.git
    cd volatility
    sudo python setup.py install
    cd
fi

# Get Cuckoo
if [ ! -d ~/src/cuckoo ]; then
    cd ~/src
    git clone https://github.com/cuckoobox/cuckoo.git
    cd cuckoo
    sudo pip install -r requirements.txt
    ./utils/community.py -wafb 2.0
    cd
fi

sudo usermod -a -G libvirt cuckoo

# Let the cuckoo user access tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

