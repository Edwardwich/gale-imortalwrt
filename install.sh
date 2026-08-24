#!/bin/sh

echo "=========================================="
echo " Interactive OpenWrt Package Installer"
echo "=========================================="

# Update package lists first
apk update

# Define repository packages (Name)
REPO_PACKAGES="btop dnsmasq-full sing-box xray-core homeproxy"

echo "--- Repository Packages ---"
for pkg in $REPO_PACKAGES; do
    printf "Do you want to install [ %s ]? (y/n): " "$pkg"
    read -r choice
    case "$choice" in
        y|Y ) 
            echo "Installing $pkg..."
            apk add "$pkg"
            ;;
        * ) 
            echo "Skipping $pkg."
            ;;
    esac
    echo ""
done


# Define external APKs (Name | URL)
EXTERNAL_APKS="
luci-theme-material3|https://github.com/KawaiiHachimi/luci-theme-material3/releases/download/v1.0.6/luci-theme-material3-26.156.15499.38397ed.apk
luci-theme-argon|https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.4.7/luci-theme-argon-2.4.7-r1.apk
luci-app-passwall2|https://github.com/Openwrt-Passwall/openwrt-passwall2/releases/download/26.8.20-1/luci-app-passwall2-26.8.20-r1.apk
"

DOWNLOAD_DIR="/tmp/openwrt_custom_installs"
mkdir -p "$DOWNLOAD_DIR"

echo "--- Themes & External Applications ---"
# Loop through each item in the external list
echo "$EXTERNAL_APKS" | while IFS='|' read -r name url; do
    # Skip empty lines
    [ -z "$name" ] && continue

    printf "Do you want to download and install [ %s ]? (y/n): " "$name"
    read -r choice
    case "$choice" in
        y|Y ) 
            echo "Downloading $name..."
            wget "$url" -P "$DOWNLOAD_DIR"
            ;;
        * ) 
            echo "Skipping $name."
            ;;
    esac
    echo ""
done


# Install any downloaded local APK packages
if [ "$(ls -A "$DOWNLOAD_DIR" 2>/dev/null)" ]; then
    echo "[+] Installing selected local APKs..."
    apk add --allow-untrusted "$DOWNLOAD_DIR"/*.apk
else
    echo "No external APKs were selected."
fi

# Cleanup
rm -rf "$DOWNLOAD_DIR"

echo "=========================================="
echo "Installation process finished!"
echo "=========================================="
