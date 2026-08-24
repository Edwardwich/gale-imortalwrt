#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================="
echo "Starting OpenWrt Package & Theme Installer"
echo "=========================================="

# 1. Update package lists
echo -r "Updating package lists..."
apk update

# 2. Install repository packages
echo -e "\n[+] Installing repository packages..."
apk add btop
apk add dnsmasq-full
apk add sing-box
apk add xray-core
apk add homeproxy

# 3. Create a temporary directory for downloaded APKs
DOWNLOAD_DIR="/tmp/openwrt_custom_installs"
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

echo -e "\n[+] Downloading custom APK packages..."

# 4. Download themes and applications
echo "Downloading luci-theme-material3..."
wget https://github.com/KawaiiHachimi/luci-theme-material3/releases/download/v1.0.6/luci-theme-material3-26.156.15499.38397ed.apk

echo "Downloading luci-theme-argon..."
wget https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.4.7/luci-theme-argon-2.4.7-r1.apk

echo "Downloading luci-app-passwall2..."
wget https://github.com/Openwrt-Passwall/openwrt-passwall2/releases/download/26.8.20-1/luci-app-passwall2-26.8.20-r1.apk

# 5. Install downloaded local APK packages
echo -e "\n[+] Installing downloaded APKs..."
apk add --allow-untrusted *.apk

# 6. Cleanup
echo -e "\n[+] Cleaning up downloaded files..."
cd /
rm -rf "$DOWNLOAD_DIR"

echo "=========================================="
echo "Installation completed successfully!"
echo "=========================================="
