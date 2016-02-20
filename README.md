cuckoo-tools
============

Tools and configs for my Kali installation.

Setup Cuckoo
============

I tested this script on Debian 8.3

    sudo apt-get install git
    git clone

Install Windows machine
=======================

Share a folder with your vm and mount it:

    mkdir $HOME/Shared
    sudo mount -t vmhgfs .host:/cuckoo $HOME/Shared

Start the installation of the Windows machine:

    virt-install --name win7_x64 --memory 2048 --cdrom en_windows_7_enterprise_with_sp1_x64_dvd_u_677651.iso --boot cdrom,hd --os-variant win7 --disk size=30

Install basics for Cuckoo

* https://www.python.org/getit/ - Python 2.7.x
* http://www.pythonware.com/products/pil/
* https://raw.githubusercontent.com/cuckoosandbox/cuckoo/master/agent/agent.py

Save _agent.py_ as _agent.pyw_ and add it to the _Startup_ folder.

Install some old apps.

* http://www.oldapps.com/java.php?old_java=15362?download - Java 7 Update 65 (x64)
* http://www.oldapps.com/flash_player.php?old_flash_player=15631?download - Adobe Flash Player 15.0.0.152 (All Versions)
* http://www.oldapps.com/adobe_reader.php?old_adobe=14774?download - Adobe Reader XI 11.0.07
* http://www.oldapps.com/VLC_Player.php?old_vlc=12100?download - VLC Player 2.0.6 (x64)

Remember to

* Turn of updates
* Turn of firewall


Using Cuckoo
============

Start Cuckoo:

    cd ~/src/cuckoo
    ./cuckoo.py

Start Cuckoo web interface at http://127.0.0.1:8000/:

    cd ~/src/cuckoo/web
    python manage.py runserver
