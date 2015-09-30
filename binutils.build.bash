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

if [[ ! -f binutils-2.25.tar.bz2  ]] ;
then
	wget http://mirror.switch.ch/ftp/mirror/gnu/binutils/binutils-2.25.tar.bz2
fi

tar xfv binutils-2.25.tar.bz2

cd binutils-2.25
find ../binutils-patches/ -name '*.patch.gz' -exec gunzip -f {} \;
for p in ../binutils-patches/*.patch; do echo Applying $p; patch -p1 < $p; done
autoconf
cd ld
autoreconf
cd ../../

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p binutils-build
cd binutils-build

CONFARGS=" \
	--enable-languages=c,c++ \
	--prefix=$PREFIX \
	--disable-nls \
	--disable-doc \
	--disable-werror \
	--enable-install-libiberty \
	--enable-install-libbfd \
	--disable-gdb \
	--disable-libdecnumber \
	--disable-readline \
	--disable-sim \
	--target=avr"

CFLAGS="-w -O2 -g0 $CFLAGS" CXXFLAGS="-w -O2 -g0 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../binutils-2.25/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS configure-host
nice -n 10 make -j $MAKE_JOBS all

make install

