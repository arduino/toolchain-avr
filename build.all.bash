#!/bin/bash -ex

rm -rf objdir toolsdir

./clean.bash
./tools.bash
./clean.bash
./binutils.build.bash
./clean.bash
./gcc.build.bash
./clean.bash
./avr-libc.build.bash
./clean.bash
./avrdude.build.bash
./clean.bash
