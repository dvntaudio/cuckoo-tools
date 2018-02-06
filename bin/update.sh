#!/bin/bash

LOG=/tmp/cuckoo-tools.log
touch "$LOG"

CUCKOO=~/src/cuckoo/.conf
export CUCKOO

# shellcheck disable=SC1090
. ~/cuckoo-tools/bin/common.sh
# shellcheck disable=SC1091
. /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# Update Debian
# shellcheck disable=SC2024
sudo apt-get update && sudo apt-get dist-upgrade >> "$LOG" 2>&1

if [ ! -e /etc/suricata/rules/tor.rules ]; then
    update_rules
fi

LAST_UPDATE_RULES=$(find /etc/suricata/rules/tor.rules -mtime +1)

[ ! -z "$LAST_UPDATE_RULES" ] && update_rules

workon cuckoo
pip install -U pip setuptools >> "$LOG" 2>&1
pip install -U cuckoo >> "$LOG" 2>&1
deactivate
