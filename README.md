cuckoo-tools
============

This a collection of scripts that installs Cuckoo 2.0-dev and required tools such as:

* Volatility
* Suricata

Setup Cuckoo
============

The script is only tested on Debian 8.3. I installed Debian from the [mini.iso](http://ftp.se.debian.org/debian/dists/jessie/main/installer-amd64/current/images/netboot/mini.iso). Basic setup with LVM and no print server. The installation instructions below assumes that the username is _cuckoo_.

When you're done with the steps below you should have a working copy of Cuckoo 2.0-dev (at the time I write this).

First thing to do is install sudo and git.

    su -
    apt-get install -y sudo git
    usermod -a -G sudo cuckoo

You have to logout for the changes of group membership to take effect.

This is also a good time to shutdown the image and take a snapshot if anything breaks during the installation of [Cuckoo](https://cuckoosandbox.org/). Don't forget to change screen settings and enable folder sharing before taking the snapshot.

    git clone https://github.com/reuteras/cuckoo-tools.git
    cd cuckoo-tools
    ./bin/setup.sh      # go get a cup of coffe...

You now have a default configuration for a Win 7 x86-64 vm in KVM. 

Optional steps to use my _.bashrc_ and _.vimrc_.

    make
    . ~/.bashrc

Now is a good time to reboot to make sure VMware hgfs works.

Install a Windows machine
=========================

Share a folder with your vm and mount it. If you have installed my .bashrc you can just run

    shared

Otherwise you can use:

    mkdir $HOME/shared
    sudo mount -t vmhgfs .host:/cuckoo $HOME/shared

Before you begin the installation remember that you have to enable virtualiztion in the vm. In VMware Fusion this is done under advanced settings for processors & memory.

To begin the installation of the Windows machine.

    virt-manager 

Name the machine win7_x64 for the defaults in this repository to work. I will not explain the steps needed here.

Install some basic tools for Cuckoo. When IE starts remember to turn of SmartScreen Filter.

* https://www.python.org/getit/ - Python 2.7.x. Install 32-bit version.
* http://www.pythonware.com/products/pil/
* https://raw.githubusercontent.com/cuckoosandbox/cuckoo/master/agent/agent.py

Save _agent.py_ as _agent.pyw_ and add it to the _Startup_ folder.

Install some old apps. Examples below:

* http://www.oldapps.com/java.php?old_java=15362?download - Java 7 Update 65 (x64)
* http://www.oldapps.com/flash_player.php?old_flash_player=15631?download - Adobe Flash Player 15.0.0.152 (All Versions)
* http://www.oldapps.com/adobe_reader.php?old_adobe=14774?download - Adobe Reader XI 11.0.07
* http://www.oldapps.com/VLC_Player.php?old_vlc=12100?download - VLC Player 2.0.6 (x64)

Remember to

* Turn off automatic updates.
* Turn off the Windows firewall.
* Disable UAC.
* Disable NTP.
* Change screen resolution to 1024x768 or higher.
* Change background.
* Add some files and bookmarks.

Note the ip address and enter it in cuckoo/conf/kvm.conf.

    vim cuckoo/conf/kvm.conf

Start _agent.pyw_ and take a snapshot of the running instance of Windows. Call the snapshot _snapshot1_.

Enable OVPN
===========

I use [OVPN](https://www.ovpn.se/) as my VPN provider and you can enable support for it this way if you have an account.

First create a file with your OVPN login information. I'll call the file ovpn-account.txt. Type your username on the first line and your password on the second line. Then run 

    ./bin/configure-ovpn.sh ~/shared/ovpn-account.txt

Using Cuckoo
============

The included start script for Cuckoo will install and update Snort rules for Suricata in Cuckoo. New rules are downloaded it the curren ones are older then 24 hours. The script will also update cuckoo.conf with the curren IP address of eth0.

Start Cuckoo:

    ./bin/start.sh

To test your installation you can download malware from http://www.tekdefense.com/downloads/malware-samples/. I recommend [340s.exe.zip](http://www.tekdefense.com/downloads/malware-samples/340s.exe.zip) which should trigger some Suricata rules. The files are password protected with the password "infected".

TODO
====

* Setup https://downloads.cuckoosandbox.org/docs/usage/utilities.html#smtp-sinkhole
* More tests...

Fixes
=====

If there is any problems with pip run the following command:

    sudo rm -rf /usr/local/lib/python2.7/dist-packages/requests*

