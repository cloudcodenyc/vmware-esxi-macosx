# vmware-esxi-macosx
 Collection of scripts for macOS on VMware-ESXi 

# Automatically download and run Latest version of Scripts:

(Run from MacOSX Terminal) - curl -L --url "https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autoiso-macos-10.11.sh" -o ~/autoiso-macos-10.11.sh;
[ -e ~/autoiso-macos-10.11.sh ] && chmod +x ~/autoiso-macos-10.11.sh && sh ~/autoiso-macos-10.11.sh

(Run from VMware ESXi Shell) - wget "https://raw.githubusercontent.com/cloudcodenyc/vmware-esxi-macosx/main/autovmx-darwin-tools.sh" -O $HOME/autovmx-darwin-tools.sh;
[ -e ~/autovmx-darwin-tools.sh ] && chmod +x ~/autovmx-darwin-tools.sh && sh ~/autovmx-darwin-tools.sh
