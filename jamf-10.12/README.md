### Installing Jamf 10.12 onto Ubuntu 18.04 with VMware and Packer on a Mac

About this template
-------------------

This template will install everything needed for Jamf except for the distribution point, which can be different server.  If you intend on putting the distribution point on the same server you will probably need to modify this template and scripts to add smb support.

Preparing for the Packer Image
------------------------------

Download and install Packer

* https://packer.io/downloads.html

Download and install VMware Fusion

* https://www.vmware.com/products/fusion.html

Download Ubuntu Installer w/ Debian Installer (it has "server" in the filename--don't use the other installers!)

* http://cdimage.ubuntu.com/releases/18.04/release/
* ubuntu-18.04.2-server-amd64.iso
* Save the file at /Users/u0076374/Packer/

Download the Jamf Pro *Linux* installer (not the dmg)

* https://www.jamf.com/jamf-nation/my/products
* "Download" link to get the Mac apps
* "Show alternative downloads" to get the Linux installer
* "Show previous releases" to get any intermediate installers
* jamf-pro-installer-linux-n.n.n.zip
* Save to copy/ (an empty placeholder file is there)

Jamf Pro Installation and Configuration Guide for Linux
------------------------------

The ["Jamf Pro Installation and Configuration Guide for Linux
Version 10.12.0"](https://docs.jamf.com/10.12.0/jamf-pro/install-guide-linux/Installing_Jamf_Pro_Using_the_Installer.html) lists requirements and steps.  Here's how the Packer template deals with them.

# Requirements

* A 64-bit capable Intel processor
* 2 GB of RAM (8 GB recommended)
* 400 MB of disk space available
* Wget utility installed
* Ports 8443 and 8080 available

All of this is set in the jamf.json file except wget, which is specified in the "pressed.cfg" file.

# Step 1 Install the Required Software

"Java and MySQL must be installed on the server before you can create the Jamf Pro database and run the Jamf Pro Installer."  These are specified in the "preseed.cfg" file.

# Step 2: Create the Jamf Pro Database

This is performed by the install.sh script.

# Step 3: Create the Jamf Pro Database

This is performed by the install.sh script.  The installer must be located in the copy directory.  An empty placeholder file is currently there.

Modifying the Packer template
----------------------------

You probably want to change these settings

* In jamf.json, install.sh change "username" (this should be the name you use for your admin user) and also replace all instances of "james" in http/preseed.cfg with the name you use.
* Modify copy/01-netcfg.yaml with your desired network settings (static IP).
* Set the "hostname" in jamf.json

I modify the passwords after the image is built and I recommend you do the same, so leave them the way they are for now ("cleartext" and "jamfsw03").

If you want to modify the packer Tempalte more than this you'll need to learn about Preseeding.

* https://help.ubuntu.com/lts/installation-guide/example-preseed.txt
* https://askubuntu.com/questions/806820/how-do-i-create-a-completely-unattended-install-of-ubuntu-desktop-16-04-1-lts
* https://help.ubuntu.com/lts/installation-guide/amd64/apbs02.html#preseed-bootparms

Build the Packer image
----------------------

Run these commands to build the image.

	cd jamf_10.12
	packer validate jamf.json

You can ignore the warning about "memsize"

	packer build jamf.json

Post Packer
----------------

When your image is built start up your VM and login using the username you specified (if you changed it) and the password "cleartext".  Type the following command.

	ip addr show

Find the IP for ens33.  In a Terminal window, ssh into the server using that IP.

	ssh your-username@192.168.89.1

# Passwords

Type in these commands and follow all prompts.

	passwd
	sudo -s
	mysql -u root -p
	ALTER USER 'jamfsoftware'@'localhost' IDENTIFIED BY 'your-password';
	exit
	mysql_secure_installation
	nano /usr/local/jss/tomcat/webapps/ROOT/WEB-INF/xml/DataBase.xml

Find "<DataBasePassword>jamfsw03</DataBasePassword>" and change it to your password.

# Reboot!

reboot

Open webpage. https://192.168.89.131:8443/index.html
