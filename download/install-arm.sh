#!/bin/sh

# This script installs the latest version of Processing for ARM into /usr/local/lib
# Run it like this: "curl https://processing.org/download/install-arm.sh | sudo sh"

# check if on a 64-bit operating system
case "$(file $(which file))" in
  *aarch64*) FLAVOR="arm64"; TAR="$(curl -sL https://api.github.com/repos/processing/processing/releases | grep -oh -m 1 'https.*linux-arm64.tgz')" ;;
  *)       FLAVOR="armv6hf"; TAR="$(curl -sL https://api.github.com/repos/processing/processing/releases | grep -oh -m 1 'https.*linux-armv6hf.tgz')" ;;
esac

echo ""
echo "Downloading $TAR..."
curl -L $TAR > processing-linux-$FLAVOR-latest.tgz

echo "Installing in /usr/local..."
tar fx processing-linux-$FLAVOR-latest.tgz -C /usr/local/lib
rm -f processing-linux-$FLAVOR-latest.tgz

# this returns the highest version installed
VER="$(basename $(ls -dvr /usr/local/lib/processing-* | head -1))"

# symlink target might be a directory, replace
rm -rf /usr/local/lib/processing
ln -s $VER /usr/local/lib/processing

# this assumes that /usr/local/bin is in $PATH
ln -sf ../lib/processing/processing /usr/local/bin/processing
ln -sf ../lib/processing/processing-java /usr/local/bin/processing-java

# this assumes that the desktop manager picks up .desktop files in /usr/local/share/applications
mkdir -p /usr/local/share/applications
curl -sL https://raw.githubusercontent.com/processing/processing/master/build/linux/processing.desktop > /usr/local/share/applications/processing.desktop
sed -i "s/@version@/$VER/" /usr/local/share/applications/processing.desktop
sed -i 's|/opt/processing|/usr/local/lib/processing|' /usr/local/share/applications/processing.desktop

# silence validation errors
desktop-file-install /usr/local/share/applications/processing.desktop >/dev/null 2>&1

echo "Done! You can start Processing by running processing in the terminal, or through the applications menu (might require a restart)."
echo ""
