#!/bin/bash

if [ "$1" == "" ]; then
        INSTALL_PATH=`pwd`/_install
else
        if [ -d $1 ]; then
                INSTALL_PATH=$1
        else
                exit 1
        fi
fi

make clean
if make; then
	cp gpio_recover $INSTALL_PATH/bin/
	exit 0
fi
exit 1
