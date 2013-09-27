#!/bin/bash -e

rm -rf objdir

./clean.bash
./binutils.build.bash
./gcc.build.bash
./avr-libc.build.bash

rm -rf objdir/{info,man,share}
