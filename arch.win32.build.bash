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

export PATH=$PATH:/c/MinGW/bin/:/c/cygwin/bin/
CFLAGS="-DWIN32" CXXFLAGS="-DWIN32" LDFLAGS="-DWIN32" CC="mingw32-gcc -m32" CXX="mingw32-g++ -m32" ./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
for folder in avr/bin bin libexec/gcc/avr/4.8.1/
do
	cp /c/MinGW/bin/libiconv-2.dll $folder
done
zip -r -9 ../avr-toolchain-win32-3.4.5.zip .

