#!/bin/bash -ex

./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
zip -r -9 ../avr-toolchain-linux64-3.4.5.zip .

