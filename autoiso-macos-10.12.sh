#!/bin/sh
#
###############################################################################
# MacOS-10.12-(Sierra): Automatically download and generate bootable ISO      #
#                                                                             #
# VERSION  = 0.0.4                                                            #
# FILENAME = autoiso-macos-10.12.sh                                           #
# LOCATION = https://github.com/cloudcodenyc/vmware-esxi-macosx               #
# LICENSE  = BSD-3                                                            #
#                                                                             #
###############################################################################
#                                                                             #
# https://bootableinstaller.com/macos/#macos                                  #
# https://gist.github.com/coolaj86/8c36d132250163011c83bad8284975ee           #
# https://gist.github.com/wrossmck/20858f8393d3bb9158a1#file-makeosxiso-sh    #
#                                                                             #
###############################################################################
	
	VERSION="10.12.X"
	RELEASE="Sierra"
	ISO_SIZE="6050m"
	
	APP_NAME="Install OS X $RELEASE"
	APP_PATH="/Applications/$APP_NAME"
	DIR_PATH="$HOME/Desktop/OSX-ISO"
	DMG_NAME="InstallOSX-$VERSION"
	ESD_NAME="InstallESD-$VERSION"
	ISO_NAME="macOS-$VERSION-$RELEASE"
	ISO_FULL="$DIR_PATH/$ISO_NAME"
	
	APPLEURL=https://support.apple.com/en-us/HT211683
	URL_1010=http://updates-http.cdn-apple.com/2019/cert/061-41343-20191023-02465f92-3ab5-4c92-bfe2-b725447a070d/InstallMacOSX.dmg
	URL_1011=http://updates-http.cdn-apple.com/2019/cert/061-41424-20191024-218af9ec-cf50-4516-9011-228c78eda3d2/InstallMacOSX.dmg
	URL_1012=http://updates-http.cdn-apple.com/2019/cert/061-39476-20191023-48f365f4-0015-4c41-9f44-39d3d2aca067/InstallOS.dmg
	
[ ! -e "$DIR_PATH" ] && mkdir "$DIR_PATH"
	[ -e "$DIR_PATH" ] && cd "$DIR_PATH" 
		[ ! -e "./$DMG_NAME".dmg ] && curl -L --url "$URL_1012" -o "$DMG_NAME".dmg

if [ -f "$DMG_NAME".dmg ]; then
	hdiutil attach "$DMG_NAME".dmg -noverify -nobrowse -mountpoint /Volumes/"$DMG_NAME"/
	pkgutil --expand $(ls /Volumes/"$DMG_NAME"/InstallOS*.pkg) "./$DMG_NAME/"
	hdiutil detach /Volumes/"$DMG_NAME" 2>/dev/null
	[ -f /Volumes/"$DMG_NAME" ] && sudo hdiutil detach /Volumes/"$DMG_NAME" 2>/dev/null
	[ ! -e ./"$DMG_NAME"/InstallOS.pkg ] && echo "ERROR: Installation FILES NOT FOUND ... QUIT" && exit 1
	mv ./"$DMG_NAME"/InstallOS.pkg/InstallESD.dmg "$DIR_PATH/$ESD_NAME".dmg;
fi

if [ -e "./$DMG_NAME/" ]; then rm -rf "./$DMG_NAME/"
	hdiutil attach "$ESD_NAME".dmg -noverify -nobrowse -mountpoint "/Volumes/$ESD_NAME/"
	# Get InstallESD.dmg Total Non-Empty Size ( Bytes )
	ESDSIZE=$(hdiutil imageinfo ./"$ESD_NAME".dmg | grep --line-buffered -e 'Total Non-Empty Bytes:' | cut -d ' ' -f4)
	[ ! -e /Volumes/"$ESD_NAME"/BaseSystem.dmg ] && echo "ERROR: Required BaseSystem.dmg file not found" && exit 1

	# Get BaseSystem.dmg Total Non-Empty Size ( Bytes )
	ESDBASE=$(hdiutil imageinfo /Volumes/"$ESD_NAME"/BaseSystem.dmg | grep --line-buffered -e 'Total Non-Empty Bytes:' | cut -d ' ' -f4)

	# Get Full ESD Size by adding values of "InstallESD.dmg" and "BaseSystem.dmg"
	ESDFULL=$(($ESDSIZE + $ESDBASE))
	# Increase ESDFULL by approximately ~200mb to allow enough room for the bootloader
	COUNT=$ESDFULL ; let "COUNT+=280000000"

	echo '' ; echo "$ESD_NAME.dmg" && echo "Filesize (bytes): $ESDSIZE"; echo '';
	echo "BaseSystem.dmg" && echo "Filesize (bytes): $ESDBASE"; echo '';
	echo "$ISO_NAME.iso" && echo "Filesize (bytes): $COUNT" && echo '';
fi

# Convert ESDSIZE from Bytes to Kilobytes ( Start at position 0 of VARIABLE and return first 7 digits ) = "${COUNT:0:7}k"
[ ! -f "$RELEASE-$VERSION.dmg" ] && hdiutil create -o ./"$RELEASE-$VERSION".dmg -size "$ISO_SIZE" -volname "$RELEASE-$VERSION" -layout SPUD -fs HFS+J
	hdiutil attach ./"$RELEASE-$VERSION".dmg -noverify -mountpoint /Volumes/"$RELEASE-$VERSION"

[ -e /Volumes/"$ESD_NAME"/BaseSystem.dmg ] && echo '' && asr restore -source /Volumes/"$ESD_NAME"/BaseSystem.dmg -target /Volumes/"$RELEASE-$VERSION" -noprompt -noverify -erase && echo ''
	hdiutil detach /Volumes/"OS X Base System" || true
	hdiutil detach /Volumes/'OS X Base System 1' 2>/dev/null ;
	hdiutil detach /Volumes/"$RELEASE-$VERSION" 2>/dev/null ;

hdiutil attach ./"$RELEASE-$VERSION".dmg -noverify -mountpoint /Volumes/"$RELEASE-$VERSION" && echo ''
	rm /Volumes/"$RELEASE-$VERSION"/System/Installation/Packages
	cp -rp /Volumes/"$ESD_NAME"/Packages     /Volumes/"$RELEASE-$VERSION"/System/Installation/
	cp -rp /Volumes/"$ESD_NAME"/BaseSystem.* /Volumes/"$RELEASE-$VERSION"
hdiutil detach /Volumes/"$RELEASE-$VERSION" ; hdiutil detach /Volumes/"$ESD_NAME" && echo ''

[ -e "./$RELEASE-$VERSION.dmg" ] && mv ./"$RELEASE-$VERSION".dmg ./"$RELEASE-$VERSION".iso
[ -e "./$RELEASE-$VERSION.iso" ] && rm ./"$ESD_NAME".dmg ./"$DMG_NAME".dmg 2>/dev/null

[ ! -e "macOS-$VERSION-$RELEASE.iso" ] && mv "$RELEASE-$VERSION".iso "macOS-$VERSION-$RELEASE".iso
[ -e "$ISO_FULL.iso" ] && echo '' && echo "MacOS ISO Success: $DIR_PATH/macOS-$VERSION-$RELEASE.iso" && echo ''

read -p "Press enter to continue"
exit 0
