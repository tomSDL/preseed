#!/bin/bash

# This script will run once after a fresh installation

# todo
# clear terminal from wrapped lines

LOG=/var/log/auto-install.log
#MAC=$(LANG=us_EN; ifconfig -a | head -1 | awk /HWaddr/'{print tolower($5)}')
if [ ! -z $1 ]; then
    MAC=$1
else
    MAC=$(ip link | sed -n "/BROADCAST.*state UP/{n;p}" | tail -1 | tr -s " " | cut -d" " -f3)
    if [ -z ${MAC} ]; then
        IFACE=$(route | grep default | sed -e's/  */ /g' | cut -d" " -f8)
        MAC=$(ip link | sed -n "/${IFACE}/{n;p}" | tail -1 | tr -s " " | cut -d" " -f3)
    fi
fi

MAC_HASH=$(echo ${MAC} | md5sum | cut -d" " -f1)

# Update the package list
apt-get update -qq | tee -a ${LOG}
apt-get dist-upgrade -y -qq | tee -a ${LOG}

# install aplications
sudo apt-get install -y openssh-server

# remove unnecessary applications
#apt-get remove -y gnome-sudoku

# clear terminal
clear

# Disable console blanking
setterm -blank 0

# Save start time
echo "--- START ${MAC} $(date) ---" >> ${LOG}

# Install basics needed for further installation or debugging
echo "MAC: ${MAC}"
echo "MAC_HASH: ${MAC_HASH}"

# get post install script for client
#wget -q "http://preseed.panticz.de/lc/${MAC_HASH}" -O /tmp/lc.sh && chmod 777 /tmp/lc.sh && . /tmp/lc.sh

# Save the end time
echo "--- START ${MAC} $(date) ---" >> ${LOG}

# Remove init script
#dep# rm /etc/rc2.d/S99install
[ -f /etc/init/late_command.conf ] && rm /etc/init/late_command.conf

# Update the package list
apt-get update -qq | tee -a ${LOG}
apt-get dist-upgrade -y -qq | tee -a ${LOG}

# clean up
apt-get clean | tee -a ${LOG}
apt-get -y autoremove | tee -a ${LOG}

# Sync and reboot
sync
sleep 3
reboot
