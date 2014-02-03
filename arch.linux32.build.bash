#!/bin/bash -ex

AUTOCONF="autoconf2.64" AUTORECONF="autoreconf2.64" CC="gcc -m32" CXX="g++ -m32" ./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
zip -r -9 ../avr-toolchain-linux32-gcc-4.8.1.zip .

