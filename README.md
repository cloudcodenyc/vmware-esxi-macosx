# vmware-esxi-macosx
 Collection of scripts for macOS on VMware-ESXi 

autoiso-macos-10.11.sh 		(Automatically download and generate bootable MacOS-10.11 ISO)
autovmx-darwin-tools.sh 	(Automatically download and activate native VMware OSX Guest Tools)

# Automatically download and run latest version of scripts direct from the Internet:

(Run from MacOSX Terminal):
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autoiso-macos-10.11.sh)"

(Run from VMware ESXi Shell):
	/bin/sh -c "$(wget https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autovmx-darwin-tools.sh -O /opt/autovmx.sh; chmod +x /opt/autovmx.sh && sh /opt/autovmx.sh)"