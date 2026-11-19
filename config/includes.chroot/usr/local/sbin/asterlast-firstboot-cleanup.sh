#!/bin/bash
set -e

# Check if it's on live-boot or not
if [ -d /run/live/medium ] || grep -q "boot=live" /proc/cmdline; then
    exit 0
fi

# Remove calamares
export DEBIAN_FRONTEND=noninteractive
apt-get purge -y \
    calamares \
    firefox \
    calamares-settings-debian \
    live-boot \
    live-boot-doc \
    live-boot-initramfs-tools \
    live-config \
    live-config-systemd \
    live-tools || true

apt-get autoremove -y || true

rm -rf /etc/calamares
rm -f /etc/xdg/autostart/calamares.desktop
rm -f /usr/share/applications/calamares.desktop
rm -f /home/*/Desktop/calamares.desktop

update-initramfs -u || true

systemctl disable asterlast-firstboot-cleanup.service
rm -f /etc/systemd/system/asterlast-firstboot-cleanup.service
rm -f /usr/local/sbin/asterlast-firstboot-cleanup.sh
systemctl daemon-reload
