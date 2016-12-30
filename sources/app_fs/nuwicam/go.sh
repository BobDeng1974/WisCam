#!/bin/sh
#
# Copyright (c) 2013 Nuvoton Technology Corp. All rights reserved.
#

PATH_ROOT=/mnt/nuwicam
cd $PATH_ROOT/bin

echo "Wi-Fi network start"
rm -f /usr/wifi
ln -s $PATH_ROOT/wifi /usr/wifi
ln -s $PATH_ROOT/etc	/tmp/etc
./go_networking.sh &

echo "http server start"
./go_boa.sh  &

telnetd -l /bin/sh &

echo "Ser2net start"
./go_ser2net.sh &

echo "RTSP server start"     
./go_stream.sh &

echo "gpio recover start"
./gpio_recover &
