#!/bin/sh
#
###############################################################################
# Enable native Guest Tools for MacOS X ("darwin") on VMware ESXi v6/v7       #
#                                                                             #
# VERSION  = 0.0.3                                                            #
# FILENAME = autovmx-darwin-tools.sh                                          #
# LOCATION = https://github.com/cloudcodenyc/vmware-esxi-macosx               #
# LICENSE  = BSD-3                                                            #
#                                                                             #
###############################################################################
# REMOVE   = rm -rf /vmfs/volumes/datastore1/.vmtools-osx/ ; rm -f /productLocker/vmtools/*darwin*
#
# https://docs.vmware.com/en/VMware-Tools
# https://kb.vmware.com/s/article/2129825 (Installing and upgrading the latest version of VMware Tools)
# https://customerconnect.vmware.com/downloads/info/slug/datacenter_cloud_infrastructure/vmware_tools/12_x
# https://docs.vmware.com/en/VMware-Tools/12.0.0/com.vmware.vsphere.vmwaretools.doc/GUID-D8892B15-73A5-4FCE-AB7D-56C2C90BD951.html

	ISOREPO=/productLocker/vmtools
	VMXREPO=/locker/packages/vmtoolsRepo/vmtools
	VMX_URL="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/"
	VMX_V11="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/11.1.0/13668589/packages/com.vmware.fusion.tools.darwin.zip.tar"
	PRE_V11="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/11.1.0/13668589/packages/com.vmware.fusion.tools.darwinPre15.zip.tar"
	VMX_V10="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/10.1.6/12989998/packages/com.vmware.fusion.tools.darwin.zip.tar"
	PRE_V10="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/10.1.6/12989998/packages/com.vmware.fusion.tools.darwinPre15.zip.tar"
	VMX_ARM="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/12.2.3/19436697/arm64/core/com.vmware.fusion.zip.tar"
	VMX_X86="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/12.2.3/19436697/x86/core/com.vmware.fusion.zip.tar"

	VMXUSER=/vmfs/volumes/datastore1/.vmtools-osx
	VACTIVE=$VMXUSER/active-vmx
	VSTABLE=$VMXUSER/darwin-stable
	VFUSION=$VMXUSER/darwin-fusion
	
[ ! -e /vmfs/volumes/datastore1 ] && echo "ERROR: CANNOT FIND PRIMARY DATASTORE" && read -p "Press enter to continue" && exit 1
[ ! -e "$VMXUSER" ] && mkdir "$VMXUSER" ; mkdir $VACTIVE $VSTABLE $VFUSION 2>/dev/null

# Download V11_ZIP and set TOOLS directory
[ ! -e "$VFUSION/darwin-fusion-11.1.0.zip.tar" ] && wget "$VMX_V11" -O "$VFUSION"/darwin-fusion-11.1.0.zip.tar
[ -f "$VFUSION/darwin-fusion-11.1.0.zip.tar" ] && TOOLS_V11="$VFUSION/darwin-fusion-11.1.0"

	# Extract V11_ZIP and copy Guest Tools to ACTIVE directory
	[ ! -e "$TOOLS_V11" ] && mkdir "$TOOLS_V11" && tar xv -C "$TOOLS_V11"/ -f "$TOOLS_V11".zip.tar && unzip -j "$TOOLS_V11/com.vmware.fusion.tools.darwin.zip" -d "$TOOLS_V11"/ ;
	[ -f "$TOOLS_V11/darwin.iso" ] && rm -f "$TOOLS_V11/com.vmware.fusion.tools.darwin.zip" "$TOOLS_V11/descriptor.xml" 2>/dev/null
	[ ! -e "$VACTIVE/darwin.iso" ] && cp -pu "$TOOLS_V11/*darwin*" $VACTIVE/
		
		# Download V11_Pre15 for Mac OS X prior to 10.11 and set TOOLS directory
		[ ! -e "$VFUSION/darwinPre15-fusion-11.1.0.zip.tar" ] && wget "$PRE_V11" -O "$VFUSION"/darwinPre15-fusion-11.1.0.zip.tar
		[ -f "$VFUSION/darwinPre15-fusion-11.1.0.zip.tar" ] && V11_PRE15="$VFUSION/darwinPre15-fusion-11.1.0"

			# Extract V11_Pre15 and copy Guest Tools to ACTIVE directory
			[ ! -e "$V11_PRE15" ] && mkdir "$V11_PRE15" && tar xv -C "$V11_PRE15"/ -f "$V11_PRE15".zip.tar && unzip -j "$V11_PRE15/com.vmware.fusion.tools.darwinPre15.zip" -d "$V11_PRE15"/ ;
			[ -f "$V11_PRE15/darwinPre15.iso" ] && rm -f "$V11_PRE15/com.vmware.fusion.tools.darwinPre15.zip" 2>/dev/null ; rm -f "$V11_PRE15/descriptor.xml" 2>/dev/null
			[ -f "$VFUSION/darwinPre15-fusion-11.1.0/darwinPre15.iso" ] && [ ! -e "$VACTIVE/darwinPre15.iso" ] && ln -s "$VFUSION/darwinPre15-fusion-11.1.0/darwinPre15.iso" "$VACTIVE/darwinPre15.iso"
			[ -f "$VFUSION/darwinPre15-fusion-11.1.0/darwinPre15.iso.sig" ] && [ ! -e "$VACTIVE/darwinPre15.iso.sig" ] && ln -s "$VFUSION/darwinPre15-fusion-11.1.0/darwinPre15.iso.sig" "$VACTIVE/darwinPre15.iso.sig"

# Download V10_ZIP and set TOOLS directory
[ ! -e "$VFUSION/darwin-fusion-10.1.6.zip.tar" ] && wget "$VMX_V10" -O "$VFUSION"/darwin-fusion-10.1.6.zip.tar
[ -f "$VFUSION/darwin-fusion-10.1.6.zip.tar" ] && TOOLS_V10="$VFUSION/darwin-fusion-10.1.6"
	
	# Extract V10_ZIP and copy Guest Tools to ACTIVE directory (IF NOT EXIST)
	[ ! -e "$TOOLS_V10" ] && mkdir "$TOOLS_V10" && tar xv -C "$TOOLS_V10"/ -f "$TOOLS_V10".zip.tar && unzip -j "$TOOLS_V10/com.vmware.fusion.tools.darwin.zip" -d "$TOOLS_V10"/ ;
	[ -f "$TOOLS_V10/darwin.iso" ] && rm -f "$TOOLS_V10/com.vmware.fusion.tools.darwin.zip" "$TOOLS_V10/descriptor.xml" 2>/dev/null
	[ ! -e "$VACTIVE/darwin.iso" ] && cd "$TOOLS_V10" && cp -pu *darwin* $VACTIVE/	

		# Download V10_Pre15 for Mac OS X prior to 10.11 and set TOOLS directory
		[ ! -e "$VFUSION/darwinPre15-fusion-10.1.6.zip.tar" ] && wget "$PRE_V10" -O "$VFUSION"/darwinPre15-fusion-10.1.6.zip.tar
		[ -f "$VFUSION/darwinPre15-fusion-10.1.6.zip.tar" ] && V10_PRE15="$VFUSION/darwinPre15-fusion-10.1.6"
	
			# Extract V10_Pre15 and copy Guest Tools to ACTIVE directory (IF NOT EXIST)
			[ ! -e "$V10_PRE15" ] && mkdir "$V10_PRE15" && tar xv -C "$V10_PRE15"/ -f "$V10_PRE15".zip.tar ; unzip -j "$V10_PRE15/com.vmware.fusion.tools.darwinPre15.zip" -d "$V10_PRE15"/ ;
			[ -f "$V10_PRE15/darwinPre15.iso" ] && rm -f "$V10_PRE15/com.vmware.fusion.tools.darwinPre15.zip" "$V10_PRE15/descriptor.xml" 2>/dev/null
			[ -f "$VFUSION/darwinPre15-fusion-10.1.6/darwinPre15.iso" ] && [ ! -e "$VACTIVE/darwinPre15.iso" ] && ln -s "$VFUSION/darwinPre15-fusion-10.1.6/darwinPre15.iso" "$VACTIVE/darwinPre15.iso"
			[ -f "$VFUSION/darwinPre15-fusion-10.1.6/darwinPre15.iso.sig" ] && [ ! -e "$VACTIVE/darwinPre15.iso.sig" ] && ln -s "$VFUSION/darwinPre15-fusion-10.1.6/darwinPre15.iso.sig" "$VACTIVE/darwinPre15.iso.sig"
		
	# Create symbolic links in "vmtoolsRepo" that redirect to VMware "darwin" Guest Tools ISO
	[ ! -e "$VMXREPO/darwin.iso" ] && cd "$VMXREPO" && ln -s "$VACTIVE"/darwin.iso ./darwin.iso
	[ ! -e "$VMXREPO/darwin.iso.sig" ] && cd "$VMXREPO" && ln -s "$VACTIVE"/darwin.iso.sig ./darwin.iso.sig
	[ -f "$VACTIVE/darwin.iso.sha" ] && [ ! -e "$VMXREPO/darwin.iso.sha" ] && cd "$VMXREPO" && ln -s "$VACTIVE"/darwin.iso.sha ./darwin.iso.sha
	# Create symbolic links in "vmtoolsRepo" that redirect to VMware "darwinPre15" Guest Tools ISO
	[ ! -e "$VMXREPO/darwinPre15.iso" ] && cd "$VMXREPO" && ln -s "$VACTIVE"/darwinPre15.iso ./darwinPre15.iso
	[ ! -e "$VMXREPO/darwinPre15.iso.sig" ] && cd "$VMXREPO" && ln -s "$VACTIVE"/darwinPre15.iso.sig ./darwinPre15.iso.sig
	[ -f "$VACTIVE/darwinPre15.iso.sha" ] && [ ! -e "$VMXREPO/darwinPre15.iso.sha" ] && cd "$VMXREPO" && ln -s "$VACTIVE"/darwin.iso.sha ./darwin.iso.sha
	
# Create symbolic links in user accessible storage that redirects to all available versions of "darwin-tools"
[ -f "$VFUSION/darwin-fusion-11.1.0/darwin.iso" ] && [ ! -e "$VMXUSER/darwin-fusion-v11.1.0.iso" ] && cd "$VMXUSER" && ln -s "$PWD/darwin-fusion/darwin-fusion-11.1.0/darwin.iso" ./vdarwin-fusion-v11.1.0.iso
[ -f "$VFUSION/darwin-fusion-10.1.6/darwin.iso" ] && [ ! -e "$VMXUSER/darwin-fusion-v10.1.6.iso" ] && cd "$VMXUSER" && ln -s "$PWD/darwin-fusion/darwin-fusion-10.1.6/darwin.iso" ./vdarwin-fusion-v10.1.6.iso
[ -f "$VFUSION/darwinPre15-fusion-11.1.0/darwin.iso" ] && [ ! -e "$VMXUSER/darwinPre15-fusion-v11.1.0.iso" ] && cd "$VMXUSER" && ln -s "$PWD/darwin-fusion/darwinPre15-fusion-11.1.0/darwin.iso" ./vdarwinPre15-fusion-v11.1.0.iso
[ -f "$VFUSION/darwinPre15-fusion-10.1.6/darwin.iso" ] && [ ! -e "$VMXUSER/darwinPre15-fusion-v10.1.6.iso" ] && cd "$VMXUSER" && ln -s "$PWD/darwin-fusion/darwinPre15-fusion-10.1.6/darwin.iso" ./vdarwinPre15-fusion-v10.1.6.iso

[ -e "$VACTIVE/darwin.iso" ] && [ -e "$VACTIVE/darwinPre15.iso" ] && ls -la /productLocker/vmtools/darwin* 2>/dev/null ; exit 0