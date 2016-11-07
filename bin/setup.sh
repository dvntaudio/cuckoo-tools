#!/bin/bash

set -e

sudo apt-get update && sudo apt-get -y dist-upgrade

# General tools
sudo apt-get -y -qq install \
    crudini \
    ctags \
    curl \
    exfat-fuse \
    exfat-utils \
    git \
    vim \
    vim-doc \
    vim-scripts \
    zip

# Tools for Vmware
sudo apt-get -y -qq install open-vm-tools-desktop fuse

# Tools for Cuckoo and others
sudo apt-get -y -qq install python python-dev libffi-dev libssl-dev \
    mongodb qemu-kvm libvirt-bin bridge-utils yara python-yara libyara3 \
    libyara-dev python-libvirt tcpdump libcap2-bin virt-manager swig \
    suricata tesseract-ocr libjpeg-dev linux-headers-"$(uname -r)" ssdeep \
    libfuzzy-dev libxml2-dev libxslt-dev libyaml-dev

# Fix problem with pip - https://github.com/pypa/pip/issues/1093
[ ! -e /usr/local/bin/pip ] && \
    sudo apt-get remove -yqq --auto-remove python-pip && \
    wget --quiet -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    sudo -H python /tmp/get-pip.py && \
    sudo ln -s /usr/local/bin/pip /usr/bin/pip && \
    sudo rm /tmp/get-pip.py && \
    sudo -H pip install pyopenssl ndg-httpsclient pyasn1 && \
    echo "Install pip from pypa.io."

# Configure suricata
if [ ! -e /etc/suricata/suricata.yaml ]; then
    sudo cp ~/cuckoo-tools/files/suricata.yaml /etc/suricata/suricata.yaml
    sudo chown root:root /etc/suricata/suricata.yaml
    sudo chmod 644 /etc/suricata/suricata.yaml
fi

if [ ! -d ~/src ]; then
    mkdir ~/src
fi    

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
    mkdir storage
    sudo setfacl -R -m user:cuckoo:7 storage
    sudo setfacl -d -R -m user:cuckoo:7 storage
    mkdir log
    sudo pip install -r requirements.txt
    ./utils/community.py -wafb 2.0
    cd
fi

# Clean up
sudo rm -rf /usr/local/lib/python2.7/dist-packages/requests*

# Install python packages globaly
sudo pip install maec pycrypto ujson mitmproxy distorm3 pytz \
    m2crypto simplejson pydeep netlib configargparse pyparsing \
    'construct<2.8' h2 click html2text watchdog tornado urwid blinker

sudo usermod -a -G libvirt cuckoo

# Let the cuckoo user access tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

# Configure Cuckoo
ROOTDIR=~/src/cuckoo/conf
HOSTIP=$(ip a s dev eth0 | grep "inet " | awk '{print $2}' | sed -e "s:/.*::")

crudini --set $ROOTDIR/auxiliary.conf mitm enabled yes
sed -i -e "s/# bpf = /bpf = /" $ROOTDIR/auxiliary.conf

crudini --set $ROOTDIR/cuckoo.conf cuckoo machinery kvm
sed -i -e "s/ip = 192.168.56.1/ip = $HOSTIP/" $ROOTDIR/cuckoo.conf

crudini --set  $ROOTDIR/kvm.conf kvm machines win7_x64
sed -i -e "s/\[cuckoo1\]/\[win7_x64\]/" $ROOTDIR/kvm.conf
crudini --set  $ROOTDIR/kvm.conf win7_x64 label win7_x64
crudini --set  $ROOTDIR/kvm.conf win7_x64 snapshot snapshot1

crudini --set  $ROOTDIR/memory.conf win7_x64 guest_profile Win7SP1x64

crudini --set  $ROOTDIR/processing.conf screenshots enabled yes
crudini --set  $ROOTDIR/processing.conf suricata enabled yes
sed -i -e "s/# socket = /socket = /" $ROOTDIR/processing.conf

crudini --set  $ROOTDIR/reporting.conf reporthtml enabled yes
crudini --set  $ROOTDIR/reporting.conf mongodb enabled yes

sudo cp ~/cuckoo-tools/files/suricata.yaml /etc/suricata

if [ ! -e ~/src/cuckoo/analyzer/windows/bin/cert.p12 ]; then
    echo -n "Fix mitmproxy. "
    mitmproxy >> ~/src/cuckoo/log/mitmproxy 2>&1 &
    MITM_PID=$!
    sleep 10
    kill -9 $MITM_PID > /dev/null 2>&1 | true
    cp ~/.mitmproxy/mitmproxy-ca-cert.p12 ~/src/cuckoo/analyzer/windows/bin/cert.p12
    sed -i -e 's/mitmdump, "-q",/mitmdump, "-q", "--no-http2",/' ~/src/cuckoo/modules/auxiliary/mitm.py
    echo "Done."
fi

