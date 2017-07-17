#!/bin/bash

MOUNTP=$(vmware-hgfsclient)

# shellcheck disable=SC1090
. ~/cuckoo-tools/bin/common.sh

if [ !  -z "$MOUNTP" ]; then
    if [ ! -d ~/shared ]; then
        mkdir ~/shared
    fi
    sudo mount -t vmhgfs ".host:/$MOUNTP $HOME/shared" > /dev/null 2>&1
fi 

STATE=$(sudo virsh net-list | grep default | awk '{print $2}')
AUTO=$(sudo virsh net-list | grep default | awk '{print $3}')

if [ "$STATE" != "active" ]; then
    sudo virsh net-start default
fi

if [ "$AUTO" == "no" ]; then
    sudo virsh net-autostart default
fi

if [ -e /var/run/suricata-command.socket ]; then
    sudo rm -f /var/run/suricata-command.socket
fi

if [ ! -e /etc/suricata/rules/tor.rules ]; then
    update_rules
fi

LAST_UPDATE_RULES=$(find /etc/suricata/rules/tor.rules -mtime +1)

[ ! -z "$LAST_UPDATE_RULES" ] && update_rules

echo -n "Starting Suricata. "
# shellcheck disable=SC2024
sudo suricata --unix-socket -D > ~/src/cuckoo/log/suricata.log 2>&1
echo "Done."

echo -n "Waiting for Suricata socket. "
while [ ! -e /var/run/suricata-command.socket ]; do
    sleep 1
    sudo chown cuckoo:cuckoo /var/run/suricata* > /dev/null 2>&1
done
echo "Done."

sudo chown cuckoo:cuckoo /var/run/suricata-command.socket

echo -n "Staring rooter script as root. "
# shellcheck disable=SC2024
sudo ~/src/cuckoo/utils/rooter.py -v -g cuckoo > \
    ~/src/cuckoo/log/rooter.log 2>&1 &
sleep 3
echo "Done."

cd ~/src/cuckoo || exit 1
echo -n "Starting Cuckoo server."
INTERFACE=$(ip addr s | grep UP | grep -v lo: | grep -v virbr | cut -d: -f2 | sed -e "s/ //g")
HOSTIP=$(ip a s dev "$INTERFACE" | grep "inet " | awk '{print $2}' | sed -e "s:/.*::")
sed -i -e "s/ip = .*/ip = $HOSTIP/" ~/src/cuckoo/conf/cuckoo.conf
./cuckoo.py -d >> log/cuckoo-cmd.log 2>&1 &
echo "Done."
cd web || exit 1

echo -n "Starting cuckoo web."
python manage.py runserver >> ../log/web.log 2>&1 &
echo "Done."
cd ..

echo -n "Waiting to start Iceeasel. "
sleep 2
echo -n "Starting. "
iceweasel http://127.0.0.1:8000 >> log/iceweasel 2>&1 &
echo "Done."

