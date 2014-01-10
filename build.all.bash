#!/bin/bash -ex

rm -rf objdir

./clean.bash
./binutils.build.bash
./gcc.build.bash
./avr-libc.build.bash
./avrdude.build.bash
./gpio-avrdude.build.bash

rm -rf objdir/{info,man,share}

