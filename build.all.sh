#!/bin/sh -ex

rm -rf objdir

./clean.sh
./binutils.build.sh
./gcc.build.sh
./avr-libc.build.sh
./avrdude.build.sh
./gpio-avrdude.build.sh

rm -rf objdir/{info,man,share}

