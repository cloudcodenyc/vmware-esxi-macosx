# vmware-esxi-macosx
Collection of scripts for macOS on VMware-ESXi 

# Automatically download and run latest version of scripts direct from the Internet:

(Run from MacOSX Terminal):
	
# autoiso-macos-10.10.sh	(Automatically download and generate bootable MacOS-10.10 ISO)
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autoiso-macos-10.10.sh)"
	
# autoiso-macos-10.11.sh	(Automatically download and generate bootable MacOS-10.11 ISO)
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autoiso-macos-10.11.sh)"

(Run from VMware ESXi Shell):
	
# autovmx-darwin-tools.sh 	(Automatically download and activate native VMware OSX Guest Tools)	
	/bin/sh -c "$(wget --no-check-certificate https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autovmx-darwin-tools.sh -O /tmp/autovmx.sh; cd /tmp; chmod +x autovmx.sh && ./autovmx.sh)"
