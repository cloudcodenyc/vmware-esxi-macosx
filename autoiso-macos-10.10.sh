#!/bin/sh
#
###############################################################################
# MacOS-10.10-(Yosemite):  Automatically download and generate bootable ISO   #
#                                                                             #
# VERSION  = 0.0.3                                                            #
# FILENAME = autoiso-macos-10.10.sh                                           #
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
	
	VERSION="10.10.X"
	RELEASE="Yosemite"
	ISO_SIZE="6800m"
	APP_NAME="Install OS X Yosemite"

	APP_PATH="/Applications/$APP_NAME"
	DIR_PATH="$HOME/Desktop/OSX-ISO"
	DMG_NAME="macOS-$VERSION-$RELEASE"
	ESD_NAME="macOS-$VERSION-InstallESD"
	ISO_FULL="$DIR_PATH/$DMG_NAME"
	
	APPLEURL=https://support.apple.com/en-us/HT211683
	APPLEWEB=http://updates-http.cdn-apple.com/2019/cert
	URL_1010=$APPLEWEB/061-41343-20191023-02465f92-3ab5-4c92-bfe2-b725447a070d/InstallMacOSX.dmg
	URL_1011=$APPLEWEB/061-41424-20191024-218af9ec-cf50-4516-9011-228c78eda3d2/InstallMacOSX.dmg
	URL_1012=$APPLEWEB/061-39476-20191023-48f365f4-0015-4c41-9f44-39d3d2aca067/InstallOS.dmg
	
[ ! -e "$DIR_PATH" ] && mkdir "$DIR_PATH"
	[ -e "$DIR_PATH" ] && cd "$DIR_PATH"
[ ! -e "$PWD/$DMG_NAME".dmg ] && echo '' && echo "Downloading InstallMacOSX.dmg (macOS-$VERSION-$RELEASE.dmg)" && curl --progress-bar -L --url "$URL_1010" -o "$DMG_NAME".dmg && echo ''

if [ -e "$DMG_NAME".dmg ]; then
	hdiutil attach "$DMG_NAME".dmg -noverify -nobrowse -mountpoint "/Volumes/Install-OSX-$VERSION/"
	pkgutil --expand /Volumes/"Install-OSX-$VERSION"/InstallMacOSX.pkg "./Install-OSX-$VERSION/"
	hdiutil detach /Volumes/"Install-OSX-$VERSION" 2>/dev/null
	[ -e /Volumes/"Install-OSX-$VERSION" ] && sudo hdiutil detach /Volumes/"Install-OSX-$VERSION" 2>/dev/null
	mv ./"Install-OSX-$VERSION"/InstallMacOSX.pkg/InstallESD.dmg "$DIR_PATH/$ESD_NAME".dmg && echo '';
fi

[ -e "./Install-OSX-$VERSION/" ] && rm -rf "./Install-OSX-$VERSION/"
	hdiutil attach "$ESD_NAME".dmg -noverify -nobrowse -mountpoint "/Volumes/OSX-$VERSION-InstallESD/"
	# Get InstallESD.dmg Total Non-Empty Size ( Bytes )
	ESDSIZE=$(hdiutil imageinfo ./"$ESD_NAME".dmg | grep --line-buffered -e 'Total Non-Empty Bytes:' | cut -d ' ' -f4)
	EFISIZE=$(hdiutil imageinfo ./"$ESD_NAME".dmg | grep --line-buffered -e 'partition-name: EFI System Partition' -A7 | grep -e 'partition-length:' | cut -d ' ' -f2)
	echo '' ; echo "$ESD_NAME.dmg" && echo "Filesize (bytes): $ESDSIZE" ; echo ''

[ ! -f "$RELEASE-$VERSION.dmg" ] && hdiutil create -o ./"$RELEASE-$VERSION".dmg -size "$ISO_SIZE" -volname "$RELEASE-$VERSION" -layout SPUD -fs HFS+J
	hdiutil attach ./"$RELEASE-$VERSION".dmg -noverify -mountpoint /Volumes/"$RELEASE-$VERSION"

[ -e /Volumes/"OSX-$VERSION-InstallESD"/BaseSystem.dmg ] && asr restore -source /Volumes/"OSX-$VERSION-InstallESD"/BaseSystem.dmg -target /Volumes/"$RELEASE-$VERSION" -noprompt -noverify -erase
	echo '' && hdiutil detach /Volumes/"OS X Base System" || true
	hdiutil detach /Volumes/'OS X Base System 1' 2>/dev/null ;
	hdiutil detach /Volumes/"$RELEASE-$VERSION" 2>/dev/null ;

hdiutil attach ./"$RELEASE-$VERSION".dmg -noverify -mountpoint /Volumes/"$RELEASE-$VERSION"
	rm /Volumes/"$RELEASE-$VERSION"/System/Installation/Packages
	cp -rp /Volumes/"OSX-$VERSION-InstallESD"/Packages              /Volumes/"$RELEASE-$VERSION"/System/Installation/
	cp -rp /Volumes/"OSX-$VERSION-InstallESD"/BaseSystem.chunklist. /Volumes/"$RELEASE-$VERSION"
	cp -rp /Volumes/"OSX-$VERSION-InstallESD"/BaseSystem.dmg        /Volumes/"$RELEASE-$VERSION"

hdiutil detach /Volumes/"$RELEASE-$VERSION"
hdiutil detach /Volumes/"OSX-$VERSION-InstallESD"

[ -e "./$RELEASE-$VERSION.dmg" ] && mv ./"$RELEASE-$VERSION".dmg ./"$RELEASE-$VERSION".iso
[ -e "./$RELEASE-$VERSION.iso" ] && rm ./"$ESD_NAME".dmg ./"$DMG_NAME".dmg 2>/dev/null

[ ! -e "macOS-$VERSION-$RELEASE.iso" ] && mv "$RELEASE-$VERSION".iso "macOS-$VERSION-$RELEASE".iso
[ -e "$ISO_FULL.iso" ] && echo '' && echo "MacOS ISO Success: $DIR_PATH/macOS-$VERSION-$RELEASE.iso" && echo ''
read -p "Press enter to continue"

exit 0
