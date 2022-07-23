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

	VMX_URL="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/"
	VMX_V11="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/11.1.0/13668589/packages/com.vmware.fusion.tools.darwin.zip.tar"
	PRE_v11="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/11.1.0/13668589/packages/com.vmware.fusion.tools.darwinPre15.zip.tar"
	VMX_V10="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/10.1.6/12989998/packages/com.vmware.fusion.tools.darwin.zip.tar"
	PRE_V10="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/10.1.6/12989998/packages/com.vmware.fusion.tools.darwinPre15.zip.tar"
	VMX_ARM="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/12.2.3/19436697/arm64/core/com.vmware.fusion.zip.tar"
	VMX_X86="http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/12.2.3/19436697/x86/core/com.vmware.fusion.zip.tar"

	ISOREPO=/productLocker/vmtools
	VMXREPO=/locker/packages/vmtoolsRepo/vmtools
	VMXUSER=/vmfs/volumes/datastore1/.vmtools-osx
	
[ ! -e /vmfs/volumes/datastore1 ] && echo "ERROR: CANNOT FIND PRIMARY DATASTORE" && read -p "Press enter to continue" && exit 1
[ ! -e "$VMXUSER" ] && mkdir "$VMXUSER" ; mkdir $VMXUSER/darwin-active $VMXUSER/darwin-stable $VMXUSER/darwin-fusion 2>/dev/null

	# Create symbolic links in user accessible storage that redirects to the "darwin-active" directory
	[ ! -e "$VMXUSER/darwin.iso" ] && cd "$VMXUSER" && ln -s "$PWD/darwin-active/darwin.iso" ./darwin.iso
	[ ! -e "$VMXUSER/darwin.iso.sha" ] && cd "$VMXUSER" && ln -s "$PWD/darwin-active/darwin.iso.sha" ./darwin.iso.sha
	[ ! -e "$VMXUSER/darwin.iso.sig" ] && cd "$VMXUSER" && ln -s "$PWD/darwin-active/darwin.iso.sig" ./darwin.iso.sig

[ ! -e "$VMXUSER/darwin-fusion/darwin-fusion-11.1.0.zip.tar" ] && wget "$VMX_V11" -O "$VMXUSER/darwin-fusion/darwin-fusion-11.1.0.zip.tar" ;
	[ -f "$VMXUSER/darwin-fusion/darwin-fusion-11.1.0.zip.tar" ] && TOOLS_V11="$VMXUSER/darwin-fusion/darwin-fusion-11.1.0"

[ ! -e "$VMXUSER/darwin-fusion/darwinPre15-fusion-11.1.0.zip.tar" ] && wget "$PRE_V11" -O "$VMXUSER/darwin-fusion/darwinPre15-fusion-11.1.0.zip.tar" ;
	[ -f "$VMXUSER/darwin-fusion/darwinPre15-fusion-11.1.0.zip.tar" ] && V11_TOOLS="$VMXUSER/darwin-fusion/darwinPre15-fusion-11.1.0"

[ ! -e $VMXUSER/darwin-fusion/darwin-fusion-10.1.6.zip.tar ] && wget "$VMX_V10" -O $VMXUSER/darwin-fusion/darwin-fusion-10.1.6.zip.tar ;
	[ -f $VMXUSER/darwin-fusion/darwin-fusion-10.1.6.zip.tar ] && TOOLS_V10="$VMXUSER/darwin-fusion/darwin-fusion-10.1.6"
		
[ ! -e "$TOOLS_V11" ] && mkdir "$TOOLS_V11" && tar xv -C "$TOOLS_V11"/ -f "$TOOLS_V11".zip.tar ; unzip -j "$TOOLS_V11/com.vmware.fusion.tools.darwin.zip" -d "$TOOLS_V11"/ ;
	[ -f "$TOOLS_V11/darwin.iso" ] && rm -f "$TOOLS_V11/com.vmware.fusion.tools.darwin.zip" "$TOOLS_V11/descriptor.xml" 2>/dev/null
		[ ! -e "$VMXUSER/darwin-active/darwin.iso" ] && cp -pu "$TOOLS_V11/*darwin*" $VMXUSER/darwin-active/
	
[ ! -e "$V11_TOOLS" ] && mkdir "$V11_TOOLS" && tar xv -C "$V11_TOOLS"/ -f "$V11_TOOLS".zip.tar ; unzip -j "$V11_TOOLS/com.vmware.fusion.tools.darwinPre15.zip" -d "$V11_TOOLS"/ ;
	[ -f "$V11_TOOLS/darwinPre15.iso" ] && rm -f "$V11_TOOLS/com.vmware.fusion.tools.darwinPre15.zip" "$V11_TOOLS/descriptor.xml" 2>/dev/null
		[ ! -e "$VMXUSER/darwin-active/darwinPre15.iso" ] && cp -pu "$V11_TOOLS/*Pre15*" $VMXUSER/darwin-active/	
	
[ ! -e "$TOOLS_V10" ] && mkdir "$TOOLS_V10" && tar xv -C "$TOOLS_V10"/ -f "$TOOLS_V10".zip.tar ; unzip -j "$TOOLS_V10/com.vmware.fusion.tools.darwin.zip" -d "$TOOLS_V10"/ ;
	[ -f "$TOOLS_V10/darwin.iso" ] && rm -f "$TOOLS_V10/com.vmware.fusion.tools.darwin.zip" "$TOOLS_V10/descriptor.xml" 2>/dev/null
		[ ! -e "$VMXUSER/darwin-active/darwin.iso" ] && cd "$TOOLS_V10" && cp -pu *darwin* $VMXUSER/darwin-active/	
	
	# Create symbolic links in "vmtoolsRepo" that redirect to VMware "darwin" Guest Tools ISO
	[ ! -e "$VMXREPO/darwin.iso" ] && cd "$VMXREPO" && ln -s "$VMXUSER"/darwin.iso ./darwin.iso
	[ ! -e "$VMXREPO/darwin.iso.sha" ] && cd "$VMXREPO" && ln -s "$VMXUSER"/darwin.iso.sha ./darwin.iso.sha
	[ ! -e "$VMXREPO/darwin.iso.sig" ] && cd "$VMXREPO" && ln -s "$VMXUSER"/darwin.iso.sig ./darwin.iso.sig
	
cd "$VMXUSER"/ ; exit 0
