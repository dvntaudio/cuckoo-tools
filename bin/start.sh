#!/bin/bash

MOUNTP=$(vmware-hgfsclient)

function update_rules(){
    RULESDIR=$(mktemp -d)
    cd $RULESDIR
    wget http://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz
    tar xvfz emerging.rules.tar.gz
    sudo mv rules/* /etc/suricata/rules/
    rm -rf $RULESDIR
}

if [ !  -z "$MOUNTP" ]; then
    if [ ! -d ~/shared ]; then
        mkdir ~/shared
    fi
    sudo mount -t vmhgfs .host:/$MOUNTP $HOME/shared
fi 

STATE=$(sudo virsh net-list | grep default | awk '{print $2}')
AUTO=$(sudo virsh net-list | grep default | awk '{print $3}')

if [ "$STATE" != "active" ]; then
    sudo virsh net-start default
fi

if [ "$AUTO" == "no" ]; then
    sudo virsh net-autostart default
fi

if [ -e /var/run/suricata/suricata-command.socket ]; then
    sudo rm -f /var/run/suricata/suricata-command.socket
fi

if [ ! -e /etc/suricata/rules/tor.rules ]; then
    update_rules
fi

LAST_UPDATE_RULES=$(find /etc/suricata/rules/tor.rules -ctime 1)

[ ! -z $LAST_UPDATE_RULES ] && update_rules

echo -n "Starting Suricata. "
sudo suricata --unix-socket -D > /dev/null 2>&1
echo "Done."

echo -n "Waiting for Suricata socket. "
while [ ! -e /var/run/suricata/suricata-command.socket ]; do
    sleep 1
    sudo chown cuckoo:cuckoo /var/run/suricata/ > /dev/null 2>&1
done
echo "Done."

sudo chown cuckoo:cuckoo /var/run/suricata/suricata-command.socket

if grep "enabled = yes" ~/src/cuckoo/conf/vpn.conf > /dev/null; then
    echo -n "Staring rooter script as root. "
    sudo ~/src/cuckoo/utils/rooter.py -v -g cuckoo > \
        ~/src/cuckoo/log/rooter.log 2>&1 &
    sleep 3
    echo "Done."
fi    

cd ~/src/cuckoo
echo -n "Starting Cuckoo server."
./cuckoo.py -d >> log/cuckoo-cmd.log 2>&1 &
echo "Done."
cd web

echo -n "Starting cuckoo web."
python manage.py runserver >> ../log/web.log 2>&1 &
echo "Done."
cd ..

echo -n "Waiting to start Iceeasel. "
sleep 2
echo -n "Starting. "
iceweasel http://127.0.0.1:8000 >> log/iceweasel 2>&1 &
echo "Done."

