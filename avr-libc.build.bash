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

source build.conf

if [[ ! -d toolsdir  ]] ;
then
	echo "You must first build the tools: run build_tools.bash"
	exit 1
fi

cd toolsdir/bin
TOOLS_BIN_PATH=`pwd`
cd -

export PATH="$TOOLS_BIN_PATH:$PATH"

if [[ ! -f avr-libc.tar.bz2 ]] ;
then
	wget $AVR_SOURCES/avr-libc.tar.bz2
fi

if [[ $OS == "Msys" || $OS == "Cygwin" ]] ; then
	# filename containing "aux" are not allowed in Windows environments
	# let's just exclude it since it's only a test
	EXCLUDE="--exclude=aux.c"
else
	EXCLUDE=""
fi
tar xfv avr-libc.tar.bz2 $EXCLUDE
mv libc/avr-libc .
rmdir libc

cd avr-libc
for p in ../avr-libc-patches/*.patch
do
	echo Applying $p
	patch -p1 < $p
done
cd -

if [[ ! -f avr8-headers.zip ]] ;
then
	wget $AVR_SOURCES/avr8-headers.zip
fi

unzip avr8-headers.zip -d avr8-headers

for i in avr8-headers/avr/io[0-9a-zA-Z]*.h
do
	cp -v -f $i avr-libc/include/avr/
done

cd avr-libc
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

export OLDPATH="$PATH"

# Add to path only if we are not cross compiling
if [[ x$CROSS_COMPILE == "x" ]]; then
export PATH="$PREFIX/bin:$PATH"
fi

mkdir -p avr-libc-build
cd avr-libc-build

CONFARGS=" \
	--prefix=$PREFIX \
	--host=avr \
	--enable-device-lib \
	--libdir=$PREFIX/lib \
	--disable-doc"

CC="avr-gcc" CXX="avr-g++" CFLAGS="-w -Os $CFLAGS" CXXFLAGS="-w -Os $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../avr-libc/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install

export PATH="$OLDPATH"
