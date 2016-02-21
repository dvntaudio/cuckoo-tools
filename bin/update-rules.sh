#!/bin/bash

TEMPDIR=$(mktemp -d)
cd $TEMPDIR
wget http://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz
tar xvfz emerging.rules.tar.gz
sudo mv rules/* /etc/suricata/rules/
rm -rf $TEMPDIR

