#!/bin/sh

echo "=========================================="
echo " Interactive OpenWrt Package Installer"
echo "=========================================="

# Update package lists first
apk update

# 1. Repository Packages
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


# 2. Themes & External Applications (Handled individually for OpenWrt/Ash compatibility)
DOWNLOAD_DIR="/tmp/openwrt_custom_installs"
mkdir -p "$DOWNLOAD_DIR"

echo "--- Themes & External Applications ---"

# --- Item 1: luci-theme-material3 ---
printf "Do you want to download and install [ luci-theme-material3 ]? (y/n): "
read -r choice
case "$choice" in
    y|Y ) 
        echo "Downloading luci-theme-material3..."
        wget https://github.com/KawaiiHachimi/luci-theme-material3/releases/download/v1.0.6/luci-theme-material3-26.156.15499.38397ed.apk -P "$DOWNLOAD_DIR"
        ;;
    * ) 
        echo "Skipping luci-theme-material3."
        ;;
esac
echo ""

# --- Item 2: luci-theme-argon ---
printf "Do you want to download and install [ luci-theme-argon ]? (y/n): "
read -r choice
case "$choice" in
    y|Y ) 
        echo "Downloading luci-theme-argon..."
        wget https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.4.7/luci-theme-argon-2.4.7-r1.apk -P "$DOWNLOAD_DIR"
        ;;
    * ) 
        echo "Skipping luci-theme-argon."
        ;;
esac
echo ""

# --- Item 3: luci-app-passwall2 ---
printf "Do you want to download and install [ luci-app-passwall2 ]? (y/n): "
read -r choice
case "$choice" in
    y|Y ) 
        echo "Downloading luci-app-passwall2..."
        wget https://github.com/Openwrt-Passwall/openwrt-passwall2/releases/download/26.8.20-1/luci-app-passwall2-26.8.20-r1.apk -P "$DOWNLOAD_DIR"
        ;;
    * ) 
        echo "Skipping luci-app-passwall2."
        ;;
esac
echo ""


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
