#!/bin/bash

set -e

# Make sure everything is up to date
sudo apt-get update && sudo apt-get dist-upgrade

# General tools
sudo apt-get install 

# Install open-vm-tools
sudo apt-get install open-vm-tools-desktop

# Install tools for Kali
sudo apt-get install recon-ng

# Remove packages that I very seldom use
sudo apt-get autoremove tex-common

# Clean up - from https://unix.stackexchange.com/questions/144655/telinit-1-and-run-a-command-there
mkdir -p /opt/clean
cp -a /etc/inittab /opt/clean/inittab
sed -i "s/\/sbin\/sulogin/\/opt\/clean\/job.sh/" /etc/inittab
cat>/opt/clean/job.sh<<EOF
#!/bin/bash
mv -fv /opt/clean/inittab /etc/inittab
chmod -x /opt/clean/job.sh
mount -o remount,ro /dev/mapper/kali-root
fsck.ext4 -vfp /dev/mapper/kali-root
zerofree -v /dev/mapper/kali-root
mount -o remount,rw /dev/mapper/kali-root
poweroff
EOF
chmod +x /opt/clean/job.sh
telinit 1
