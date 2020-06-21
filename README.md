# cuckoo-tools

![Linter](https://github.com/reuteras/cuckoo-tools/workflows/Linter/badge.svg)

This a collection of scripts that installs Cuckoo 2.0 and required tools.

## Requirements

* To run Cuckoo inside VMware Fusion you must enable support for a hypervisor in the virtual machine.
* The script is last tested with Debian 9.6.

## Setup Cuckoo

I install Debian and run this script automatically from the cuckoo target in my [packer](https://github.com/reuteras/packer) repo which means I can skip directly to the section on how to install a Windows machine.

First thing is install **sudo** and **git**. For this you have to *su -* to *root*. This is the _only_ thing you should run in a root shell. Everything else should be executed as the _cuckoo_ user.

    su -
    apt-get install -y sudo git
    usermod -a -G sudo cuckoo
    exit

You have to logout for the group membership changes to take effect. Login in again as the _cuckoo_ user.

    git clone https://github.com/reuteras/cuckoo-tools.git
    # Change screen settings and other preferences.
    # Enable folder sharing to make it easier to share malware

This is a good time to shutdown the virtual machine and take a snapshot if anything breaks during the installation of [Cuckoo](https://cuckoosandbox.org/).

    cd cuckoo-tools
    ./bin/setup.sh      # go get a cup of coffee...

You now have a default configuration for a Win 7 x86-64 virtual machine in KVM.

Optional steps to use my _.bashrc_ and _.vimrc_.

    make install
    sudo reboot     # make sure VMware hgfs works.

## Install a Windows machine

Share a folder with your virtual machine and mount it. If you have installed my .bashrc you can just run

    shared

Otherwise you can use:

    mkdir $HOME/shared
    sudo mount -t vmhgfs .host:/cuckoo $HOME/shared

Before you begin the installation remember that you *have* to enable virtualiztion in the virtual machine. In VMware Fusion this is done under advanced settings for processors & memory. If you don't do this change you can't install Windows in the client.

To begin the installation of the Windows machine.

    virt-manager

Name the machine win7_x64 for the defaults in this repository to work. I will not explain the steps needed here.

Install some basic tools for Cuckoo. When IE starts remember to turn of SmartScreen Filter.

* https://www.python.org/getit/ - Python 2.7.x. Install 32-bit version.
* http://www.pythonware.com/products/pil/
* https://raw.githubusercontent.com/cuckoosandbox/cuckoo/master/cuckoo/data/agent/agent.py

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
* Disable update services

Other things to consider includes

* Disable [Teredo](https://technet.microsoft.com/en-us/library/ee126159%28v=ws.10%29.aspx?f=255&MSPPError=-2147217396). Run * *netsh interface teredo* and *set state disabled*.

Note the ip address and enter it in cuckoo/conf/kvm.conf.

    vim cuckoo/conf/kvm.conf

Start _agent.pyw_ and take a snapshot of the running instance of Windows. Call the snapshot _snapshot1_.

## Enable OVPN

I use [OVPN](https://www.ovpn.com/) as my VPN provider and you can enable support for it this way if you have an account. I tried to use it with the built in support in Cuckoo 2.0-dev but didn't get it to work correctly so now the script enables VPN globally for Debian.

First create a file with your OVPN login information. I'll call the file ovpn-account.txt. Type your username on the first line and your password on the second line. Then run

    ./bin/enable-global-ovpn.sh ~/shared/ovpn-account.txt

## Using Cuckoo

You should now have a working copy of Cuckoo 2.0. Cuckoo and Volatility are installed in _~/src_. If you would like to change anything in the Cuckoo conf the files are located under _~src/cuckoo/.conf/conf/_. The setup scripts makes some changes to the default configuration files.

The included start script for Cuckoo will install and update Snort rules for Suricata in Cuckoo. New rules are downloaded if the current ones are older then 24 hours. The script will also update cuckoo.conf with the current IP address of eth0.

Start Cuckoo:

    ./bin/start.sh

To test your installation you can download malware from http://www.tekdefense.com/downloads/malware-samples/. I recommend [340s.exe.zip](http://www.tekdefense.com/downloads/malware-samples/340s.exe.zip) which should trigger some Suricata rules. The files are password protected with the password "infected".
