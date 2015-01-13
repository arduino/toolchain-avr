#!/bin/bash -ex

CC="gcc -m32" CXX="g++ -m32" ./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
zip -r -9 ../avr-toolchain-linux32-3.4.5.zip .

