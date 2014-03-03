#!/bin/bash -ex

export PATH=/opt/local/libexec/gnubin/:$PATH

LIBUSB_PARAMS="-I/opt/local/include/libusb-1.0/ -L/opt/local/lib"
CC="gcc -arch i386 -mmacosx-version-min=10.5" CXX="g++ -arch i386 -mmacosx-version-min=10.5" CFLAGS="$CFLAGS $LIBUSB_PARAMS" CXXFLAGS="$CXXFLAGS $LIBUSB_PARAMS" ./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
zip -r -9 ../avr-toolchain-mac32-gcc-4.8.1.zip .

