#!/bin/bash -ex

# On Mac OS X install wget using Macports:
#
#   sudo port selfupdate
#   sudo port upgrade outdated
#   sudo port install wget

rm -rf objdir

./clean.bash
./binutils.build.bash
./gcc.build.bash
./avr-libc.build.bash
./avrdude.build.bash
./gpio-avrdude.build.bash

rm -rf objdir/{info,man,share}
