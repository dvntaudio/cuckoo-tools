#!/bin/bash

. ~/cuckoo-tools/bin/common.sh

# Update Debian
sudo apt-get update && sudo apt-get dist-upgrade

if [ ! -e /etc/suricata/rules/tor.rules ]; then
    update_rules
fi

LAST_UPDATE_RULES=$(find /etc/suricata/rules/tor.rules -mtime +1)

[ ! -z $LAST_UPDATE_RULES ] && update_rules

