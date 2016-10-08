cuckoo-tools
============

This a collection of scripts that installs Cuckoo 2.0-dev and required tools such as:

* Volatility
* Suricata

Setup Cuckoo
============

The script is only tested on Debian 8.3. I installed Debian from the [mini.iso](http://ftp.se.debian.org/debian/dists/jessie/main/installer-amd64/current/images/netboot/mini.iso). Basic setup with LVM and no print server. The installation instructions below assumes that the username is _cuckoo_.

When you're done with the steps below you should have a working copy of Cuckoo 2.0-dev (at the time I write this). Cuckoo and Volatility is installed under _~/src_. If you would like to change anything in the Cuckoo conf the files are located under _~src/cuckoo/conf/_.

First thing to do is install **sudo** and **git**. For this you have to *su -* to *root*. This is the only thing you should run in a root shell. Everything else should be executed as the _cuckoo_ user.

    su -
    apt-get install -y sudo git
    usermod -a -G sudo cuckoo
    exit

You have to logout for the group membership changes to take effect. Login in again as the _cuckoo_ user.

This is a good time to shutdown the image and take a snapshot if anything breaks during the installation of [Cuckoo](https://cuckoosandbox.org/). Don't forget to change screen settings and enable folder sharing before taking the snapshot.

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

Before you begin the installation remember that you *have* to enable virtualiztion in the vm. In VMware Fusion this is done under advanced settings for processors & memory. If you don't do this change you can't install Windows in the client.

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

Other things to consider includes

* Disable [Teredo](https://technet.microsoft.com/en-us/library/ee126159%28v=ws.10%29.aspx?f=255&MSPPError=-2147217396). Run * *netsh interface teredo* and *set state disabled*.

Note the ip address and enter it in cuckoo/conf/kvm.conf.

    vim cuckoo/conf/kvm.conf

Start _agent.pyw_ and take a snapshot of the running instance of Windows. Call the snapshot _snapshot1_.

Enable OVPN
===========

I use [OVPN](https://www.ovpn.se/) as my VPN provider and you can enable support for it this way if you have an account. I tried to use it with the built in support i Cuckoo 2.0-dev but didn't get it to work correctly so now the script enables VPN globaly for Debian.

First create a file with your OVPN login information. I'll call the file ovpn-account.txt. Type your username on the first line and your password on the second line. Then run 

    ./bin/enable-global-ovpn.sh ~/shared/ovpn-account.txt

Using Cuckoo
============

The included start script for Cuckoo will install and update Snort rules for Suricata in Cuckoo. New rules are downloaded it the curren ones are older then 24 hours. The script will also update cuckoo.conf with the curren IP address of eth0.

Start Cuckoo:

    ./bin/start.sh

To test your installation you can download malware from http://www.tekdefense.com/downloads/malware-samples/. I recommend [340s.exe.zip](http://www.tekdefense.com/downloads/malware-samples/340s.exe.zip) which should trigger some Suricata rules. The files are password protected with the password "infected".

Running under libvirt
=====================

If you use libvirt and kvm to run the Cuckoo server you have to enable support for kvm in kvm. From [this](http://kashyapc.com/2012/01/14/nested-virtualization-with-kvm-intel/) page I found the instruction to add the following to _/etc/modprobe.d/local.conf_:

    options kvm-intel nested=y

You can verify that this is enabled and working:

    cat /sys/module/kvm_intel/parameters/nested
    Y

TODO
====

* Setup https://downloads.cuckoosandbox.org/docs/usage/utilities.html#smtp-sinkhole
* Look at http://blog.scottlowe.org/2013/05/29/a-quick-introduction-to-linux-policy-routing/ for VPN config example.
* More tests...

