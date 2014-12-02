#!/bin/bash

# Update Debian
sudo apt-get update && sudo apt-get dist-upgrade

tempfoo=$(basename $0)
TMPFILE=$(mktemp /tmp/${tempfoo}.XXXXXX) || exit 1

# Update Python packages
/usr/bin/pip freeze | cut -f1 -d= | \
    egrep -v "(git-remote-helpers|Brlapi|GnuPGInterface|Magic-file-extensions|apt-xapian-index|dpkt|reportbug)" > $TMPFILE
/usr/bin/pip install --upgrade -r $TMPFILE
rm -f $TMPFILE

# Update Cuckoo
cd ~/src/cuckoo/conf
test -d ../../conf/cuckoo/ || mkdir -p ../../conf/cuckoo/
cp auxiliary.conf cuckoo.conf kvm.conf reporting.conf ../../conf/cuckoo/
git reset ORIG_HEAD --hard
git pull
cp ../../conf/cuckoo/* .

# Update Volatility
cd ~/src/volatility
git pull
sudo make install

