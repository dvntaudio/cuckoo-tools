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
sudo apt-get update >> "$LOG" 2>&1
# shellcheck disable=SC2024
while ! sudo apt-get -y dist-upgrade >> "$LOG" 2>&1 ; do
    echo "APT busy. Will retry in 10 seconds."
    sleep 10
done
info-message "Done with apt-get dist-upgrade."

if [ ! -e /etc/suricata/rules/tor.rules ]; then
    update_rules
fi

LAST_UPDATE_RULES=$(find /etc/suricata/rules/tor.rules -mtime +1)

[ ! -z "$LAST_UPDATE_RULES" ] && update_rules

workon cuckoo
pip install -U pip setuptools >> "$LOG" 2>&1
info-message "Updated pip and setuptools."
pip install -U cuckoo >> "$LOG" 2>&1
info-message "Updated cuckoo."
cuckoo community >> "$LOG" 2>&1
info-message "Updated cuckoo community files."
deactivate
info-message "Update done."
