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

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

if [[ `uname -s` == CYGWIN* || `uname -s` == MINGW* ]]
then
	if [[ ! -f libusb-win32-bin-1.2.6.0.zip  ]] ;
	then
		wget http://download.sourceforge.net/project/libusb-win32/libusb-win32-releases/1.2.6.0/libusb-win32-bin-1.2.6.0.zip
	fi

	mkdir -p tmp
	rm -rf tmp/libusb-win32-bin*
	cd tmp
	unzip ../libusb-win32-bin-1.2.6.0.zip
	cd libusb-win32-bin*
	LIBUSB_DIR=`pwd`
	cd ../..

	mkdir -p $PREFIX/bin
	cp $LIBUSB_DIR/bin/x86/libusb0_x86.dll $PREFIX/bin/libusb0.dll
fi

if [ `uname -s` == "Linux" ] || [ `uname -s` == "Darwin" ]
then
	if [[ ! -f libusb-1.0.20.tar.bz2  ]] ;
	then
		wget http://download.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2
	fi

	tar xfv libusb-1.0.20.tar.bz2

	mkdir -p libusb-1.0-build
	cd libusb-1.0-build

	CONFARGS=" \
		--prefix=$PREFIX \
		--disable-udev \
		--enable-static \
		--enable-shared"

	CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../libusb-1.0.20/configure $CONFARGS

	nice -n 10 make -j 1

	make install

	cd ..

	if [[ ! -f libusb-compat-0.1.5.tar.bz2  ]] ;
	then
		wget http://download.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2
	fi

	tar xfv libusb-compat-0.1.5.tar.bz2

	mkdir -p libusb-0.1-build
	cd libusb-0.1-build

	CONFARGS=" \
		--prefix=$PREFIX \
		--enable-static \
		--enable-shared"

	PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig" CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../libusb-compat-0.1.5/configure $CONFARGS

	nice -n 10 make -j 1

	make install
fi
