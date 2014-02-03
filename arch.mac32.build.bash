#!/bin/bash -ex

export PATH=/opt/local/libexec/gnubin/:$PATH

AUTOCONF="autoconf264" AUTORECONF="autoreconf264" CC="gcc -arch i386 -mmacosx-version-min=10.5" CXX="g++ -arch i386 -mmacosx-version-min=10.5" ./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
zip -r -9 ../avr-toolchain-mac32-gcc-4.8.1.zip .

