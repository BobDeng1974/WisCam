#!/bin/sh
# Copyright (c) Nuvoton Technology Corp. All rights reserved.
# Description:	NABTO startup script

WPA_CONFIG_FILE=/tmp/wpa.conf
NETWORK_CONFIG_FILE=/mnt/nuwicam/etc/network_config
NETWORK_CONFIG_DEFAULT_FILE=/mnt/nuwicam/wifi/network_config.default
if [ -f $WPA_CONFIG_FILE ]; then
	rm $WPA_CONFIG_FILE 
fi

cp $NETWORK_CONFIG_DEFAULT_FILE $NETWORK_CONFIG_FILE 

sync
reboot
exit 0
