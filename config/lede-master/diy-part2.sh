#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
#
# Set Default Password
sed -i 's|root::0:0:99999:7:::|root:$6$abc123$zYX1z9A6TLP63a7s3O.VziPU5y6WbbM.XgJxN7.yKDkKmYh08s/1YJ7UbjOoCnA8U2eyjIqZB7i29GO18L1:18993:0:99999:7:::/g' package/base-files/files/etc/shadow
#
# SSID
sed -i "s/lede-master/JOE-WRT/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

rm -rf ./package/lede-master/default-settings/files/openwrt_banner
svn export https://github.com/jauharimtikhan/amlogic-s9xxx-openwrt/blob/main/config/lede-master/banner package/lede-master/default-settings/files/openwrt_banner



# speedtest
mkdir -p files/bin
wget -qO- https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-aarch64.tgz | tar xOvz > files/bin/speedtest
chmod +x files/bin/speedtest
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

