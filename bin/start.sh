#!/bin/bash

MOUNTP=$(vmware-hgfsclient)

if [ !  -z "$MOUNTP" ]; then
    if [ ! -d ~/shared ]; then
        mkdir ~/shared
    fi
    sudo mount -t vmhgfs .host:/MOUNTP $HOME/shared
fi    
