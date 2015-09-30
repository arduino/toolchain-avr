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

if [[ ! -d toolsdir  ]] ;
then
	echo "You must first build the tools: run build_tools.bash"
	exit 1
fi

cd toolsdir/bin
TOOLS_BIN_PATH=`pwd`
cd -

export PATH="$TOOLS_BIN_PATH:$PATH"

if [[ ! -f avr-libc-1.8.0.tar.bz2 ]] ;
then
	wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.8.0.tar.bz2
fi

tar xfv avr-libc-1.8.0.tar.bz2

cd avr-libc-1.8.0
for p in ../avr-libc-patches/*.patch; do echo Applying $p; patch --binary -p1 < $p; done
cd -

if [[ ! -f avr8-headers.zip ]] ;
then
	wget http://distribute.atmel.no/tools/opensource/Atmel-AVR-GNU-Toolchain/3.5.0/avr8-headers.zip
fi

unzip avr8-headers.zip
mv avr avr8-headers

for i in avr8-headers/io[0-9a-zA-Z]*.h
do
	cp -v -f $i avr-libc-1.8.0/include/avr/
done

cd avr-libc-1.8.0
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p avr-libc-build
cd avr-libc-build

CONFARGS=" \
	--prefix=$PREFIX \
	--host=avr \
	--enable-device-lib \
	--disable-doc \
	--disable-versioned-doc"

PATH=$PREFIX/bin:$PATH CC="avr-gcc" CXX="avr-g++" CFLAGS="-w -Os $CFLAGS" CXXFLAGS="-w -Os $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../avr-libc-1.8.0/configure $CONFARGS

for p in ../avr-libc-patches/*.patch.post.automake; do echo Applying $p; patch -p1 < $p; done

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

PATH=$PREFIX/bin:$PATH nice -n 10 make -j $MAKE_JOBS

PATH=$PREFIX/bin:$PATH make install

