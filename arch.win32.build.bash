#!/bin/bash -ex

if [[ ! -f libusb-win32-bin-1.2.6.0.zip  ]] ;
then
	wget http://switch.dl.sourceforge.net/project/libusb-win32/libusb-win32-releases/1.2.6.0/libusb-win32-bin-1.2.6.0.zip
fi

rm -rf windowsonly
mkdir -p windowsonly
cd windowsonly

unzip ../libusb-win32-bin-1.2.6.0.zip
WINDOWS_ONLY_DIR=`pwd`

cd -

ADDITIONAL_FLAGS="-I$WINDOWS_ONLY_DIR/libusb-win32-bin-1.2.6.0/include -L$WINDOWS_ONLY_DIR/libusb-win32-bin-1.2.6.0/lib/gcc"

export PATH=/cygdrive/c/cygwin/bin:$PATH
CFLAGS="-DWIN32 $ADDITIONAL_FLAGS" CXXFLAGS="-DWIN32 $ADDITIONAL_FLAGS" LDFLAGS="-DWIN32 $ADDITIONAL_FLAGS" CC="gcc -m32" CXX="g++ -m32" ./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
zip -r -9 ../avr-toolchain-win32-gcc-4.8.1.zip .

