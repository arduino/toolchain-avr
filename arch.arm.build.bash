#!/bin/bash -ex

./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
zip -r -9 ../avr-toolchain-armv7l-gcc-4.8.1.zip .

