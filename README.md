cuckoo-tools
============

Tools and configs for my Kali installation.

Setup Cuckoo
============

I tested this script on Debian 8.3. I used the [mini.iso](http://ftp.se.debian.org/debian/dists/jessie/main/installer-amd64/current/images/netboot/mini.iso) and the first thing to do is fix sudo.

    su -
    apt-get install -y sudo
    usermod -a -G sudo cuckoo

This is a good time to shutdown the image and take a snapshot if anything breaks during the installation of [Cuckoo](https://cuckoosandbox.org/).

    sudo apt-get install -y git
    git clone https://github.com/reuteras/cuckoo-tools.git
    cd cuckoo-tools
    ./bin/setup.sh

If there is any problems with pip run the following command:

    sudo rm -rf /usr/local/lib/python2.7/dist-packages/requests*

Install Windows machine
=======================

Share a folder with your vm and mount it:

    mkdir $HOME/Shared
    sudo mount -t vmhgfs .host:/cuckoo $HOME/Shared

Start the installation of the Windows machine:

    virt-manager 

Name the machine win7_x64 for example. When done remember to take a snapshot of the machine when it is running.

Install basics for Cuckoo

* https://www.python.org/getit/ - Python 2.7.x
* http://www.pythonware.com/products/pil/
* https://raw.githubusercontent.com/cuckoosandbox/cuckoo/master/agent/agent.py

Run the following to fix python for pil on x64

    reg copy HKLM\SOFTWARE\Python HKLM\SOFTWARE\Wow6432Node\Python /s

Save _agent.py_ as _agent.pyw_ and add it to the _Startup_ folder.

Install some old apps.

* http://www.oldapps.com/java.php?old_java=15362?download - Java 7 Update 65 (x64)
* http://www.oldapps.com/flash_player.php?old_flash_player=15631?download - Adobe Flash Player 15.0.0.152 (All Versions)
* http://www.oldapps.com/adobe_reader.php?old_adobe=14774?download - Adobe Reader XI 11.0.07
* http://www.oldapps.com/VLC_Player.php?old_vlc=12100?download - VLC Player 2.0.6 (x64)

Remember to

* Turn of updates
* Turn of firewall
* Disable UAC
* Change screen resolution to 1024x768 or higher
* Note the ip and enter it in cuckoo/conf/kvm.conf
* Disable NTP


Using Cuckoo
============

Start Cuckoo:

    cd ~/src/cuckoo
    ./cuckoo.py

Start Cuckoo web interface at http://127.0.0.1:8000/:

    cd ~/src/cuckoo/web
    python manage.py runserver

TODO
====

* Setup https://downloads.cuckoosandbox.org/docs/usage/utilities.html#smtp-sinkhole
