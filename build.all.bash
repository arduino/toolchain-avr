#!/bin/bash -ex
# Copyright (c) 2014-2015 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

rm -rf toolsdir avr avrdude-6.1

if [[ `nproc` > "2" ]]; then
    JOBS=$((`nproc`+1))
fi

./clean.bash
MAKE_JOBS="$JOBS" ./tools.bash
./clean.bash

rm -rf objdir*

./clean.bash
MAKE_JOBS="$JOBS" ./binutils.build.bash
./clean.bash
MAKE_JOBS="$JOBS" ./gcc.build.bash
./clean.bash
MAKE_JOBS="$JOBS" ./avr-libc.build.bash
./clean.bash
MAKE_JOBS="$JOBS" ./gdb.build.bash
./clean.bash

if [ -z "$EXECUTABLE_FIND_FILTER" ]; then
	EXECUTABLE_FIND_FILTER="-executable"
fi

cd objdir
find bin/ -type f $EXECUTABLE_FIND_FILTER -exec strip {} \;
if [ -e "libexec" ]; then
	find libexec/ -type f $EXECUTABLE_FIND_FILTER -exec strip {} \;
	find libexec/ -type f -name '*.a' -exec strip {} \;
fi
find avr/lib lib/gcc/avr -type f -name '*.a' -exec bin/avr-strip --strip-debug {} \;
cd -

mv objdir avr

mkdir objdir

./clean.bash
MAKE_JOBS="$JOBS" ./libusb.build.bash
./clean.bash
MAKE_JOBS="$JOBS" ./avrdude.build.bash
./clean.bash

mv objdir avrdude-6.1

