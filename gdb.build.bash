#!/usr/bin/env bash
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

set -ex

if [[ ! -d toolsdir  ]] ;
then
	echo "You must first build the tools: run build_tools.bash"
	exit 1
fi

cd toolsdir/bin
TOOLS_BIN_PATH=`pwd`
cd -

export PATH="$TOOLS_BIN_PATH:$PATH"
MAKE=make

if [ `uname -s` == "FreeBSD" ] ;
then
	MAKE=gmake
fi
 
if [[ ! -f avr-gdb.tar.bz2  ]] ;
then
	wget http://distribute.atmel.no/tools/opensource/Atmel-AVR-GNU-Toolchain/3.5.3/avr-gdb.tar.bz2
fi

tar xfv avr-gdb.tar.bz2

cd gdb
for p in ../avr-gdb-patches/*.patch
do
	echo Applying $p
	patch -p1 < $p
done
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p gdb-build
cd gdb-build

CONFARGS=" \
	--prefix=$PREFIX \
	--disable-nls \
	--disable-werror \
	--disable-binutils \
	--target=avr"

CFLAGS="-w -O2 -g0 $CFLAGS" CXXFLAGS="-w -O2 -g0 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../gdb/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 $MAKE -j $MAKE_JOBS

$MAKE install

