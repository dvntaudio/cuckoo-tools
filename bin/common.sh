#!/bin/bash

function update_rules(){
    RULESDIR=$(mktemp -d)
    cd "$RULESDIR" || exit 1
    wget -q http://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz
    tar xfz emerging.rules.tar.gz
    sudo mv rules/* /etc/suricata/rules/
    rm -rf "$RULESDIR"
    info-message "Updated rules."
}

function info-message() {
    echo "**** INFO: $*"
}

function error-message() {
    (>&2 echo "**** ERROR: $*")
}
