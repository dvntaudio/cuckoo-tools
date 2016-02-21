#!/bin/bash

MOUNTP=$(vmware-hgfsclient)

if [ !  -z "$var" ]; then
    if [ ! -d ~/shared ]; then
        mkdir ~/shared
    fi
    sudo mount -t vmhgfs .host:/MOUNTP $HOME/shared
fi    
