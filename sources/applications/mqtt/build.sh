#!/bin/bash
MQTT_PATH="paho.mqtt.embedded-c"
BUILD_PATH="builddir"
MQTT_PRO="MQTTClient-C/samples/linux"


if [ "$1" == "" ]; then
        INSTALL_PATH=`pwd`/_install
else
        if [ -d $1 ]; then
                INSTALL_PATH=$1
        else
                exit 1
        fi
fi

tar zvxf $MQTT_PATH".tar.gz"

cd $MQTT_PATH
if [ -d $BUILD_PATH ]; then
	cd $BUILD_PATH
else
	mkdir $BUILD_PATH
	cd $BUILD_PATH
fi

cmake .. -DCMAKE_C_COMPILER=arm-linux-gcc -DCMAKE_CXX_COMPILER=arm-linux-g++
cd $MQTT_PRO

if make; then
	cp wiscam-mqtt $INSTALL_PATH/bin/ 
	exit 0
fi

#make clean
#if make; then
	
#	cp gpio_recover $INSTALL_PATH/bin/
#	exit 0
#fi
exit 1
