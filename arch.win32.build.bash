#!/bin/bash -ex

export PATH=/cygdrive/c/cygwin/opt/gcc-tools/bin/:/cygdrive/c/cygwin/bin:$PATH
AUTOCONF="autoconf-2.64" AUTORECONF="autoreconf-2.64" CFLAGS="-DWIN32" CXXFLAGS="-DWIN32" LDFLAGS="-DWIN32" CC="gcc -m32" CXX="g++ -m32" ./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
zip -r -9 ../avr-toolchain-win32-gcc-4.8.1.zip .

