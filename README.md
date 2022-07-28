# vmware-esxi-macosx
Collection of scripts for macOS on VMware-ESXi 

# (VMware ESXi Shell): Activate VMware OSX Guest Tools:
# VMTools "darwin-fusion"
	/bin/sh -c "$(wget --no-check-certificate https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autovmx-darwin-tools.sh -O /tmp/autovmx.sh; cd /tmp; chmod +x autovmx.sh && ./autovmx.sh)"


# (Mac OS X Terminal): Autogenerate bootable ISO:
# MacOSX v10.10
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autoiso-macos-10.10.sh)"
	
# MacOS v10.11
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autoiso-macos-10.11.sh)"

# MacOS v10.12
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autoiso-macos-10.11.sh)"
