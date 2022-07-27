# vmware-esxi-macosx
Collection of scripts for macOS on VMware-ESXi 

Automatically download and run latest version of scripts

# (Run from MacOSX Terminal):

# Automatically download and generate bootable: "MacOSX v10.10"
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autoiso-macos-10.10.sh)"
	
# Automatically download and generate bootable): "MacOS v10.11"
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autoiso-macos-10.11.sh)"

# (Run from VMware ESXi Shell):
	
# Automatically activate VMware OSX Guest Tools: "darwin-fusion"
	/bin/sh -c "$(wget --no-check-certificate https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autovmx-darwin-tools.sh -O /tmp/autovmx.sh; cd /tmp; chmod +x autovmx.sh && ./autovmx.sh)"
