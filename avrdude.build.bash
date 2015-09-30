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

if [[ ! -f avrdude-6.1.tar.gz  ]] ;
then
	wget http://download.savannah.gnu.org/releases/avrdude/avrdude-6.1.tar.gz
fi

tar xfv avrdude-6.1.tar.gz

cd avrdude-6.1
for p in ../avrdude-patches/*.patch; do echo Applying $p; patch -p0 < $p; done
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

if [[ `uname -s` == CYGWIN* || `uname -s` == MINGW* ]]
then
	cd tmp/libusb-win32-bin*
	LIBUSB_DIR=`pwd`
	cd ../..

	CFLAGS="$CFLAGS -I$LIBUSB_DIR/include -L$LIBUSB_DIR/lib/gcc"
	CXXFLAGS="$CXXFLAGS -I$LIBUSB_DIR/include -L$LIBUSB_DIR/lib/gcc"
	LDFLAGS="$LDFLAGS -I$LIBUSB_DIR/include -L$LIBUSB_DIR/lib/gcc"
fi

if [ `uname -s` == "Linux" ] || [ `uname -s` == "Darwin" ]
then
	CFLAGS="$CFLAGS -DHAVE_STDINT_H -I$PREFIX/include -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
	CXXFLAGS="$CXXFLAGS -DHAVE_STDINT_H -I$PREFIX/include -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
	LDFLAGS="$LDFLAGS -L$PREFIX/lib"
fi

mkdir -p avrdude-build
cd avrdude-build

CONFARGS=" \
	--prefix=$PREFIX \
	--enable-linuxgpio \
	--disable-parport"

CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../avrdude-6.1/configure $CONFARGS > avrdude.configure.output

cat avrdude.configure.output
DOESNTHAVELIBUSB="DON'T HAVE libusb"
DOESNTHAVELIBUSB1="DON'T HAVE libusb_1_0"
CHECKLIBUSB=`grep "DON'T HAVE libusb" avrdude.configure.output || echo`
CHECKLIBUSB1=`grep "DON'T HAVE libusb_1_0" avrdude.configure.output || echo`
rm avrdude.configure.output

if [[ `uname -s` == CYGWIN* || `uname -s` == MINGW* ]]; then
	if [[ "$CHECKLIBUSB" == "$DOESNTHAVELIBUSB" && "$CHECKLIBUSB1" == "$DOESNTHAVELIBUSB1" ]]; then
		echo "avrdude missing libusb support"
		exit 1
	fi
else
	if [[ "$CHECKLIBUSB" == "$DOESNTHAVELIBUSB" || "$CHECKLIBUSB1" == "$DOESNTHAVELIBUSB1" ]]; then
		echo "avrdude missing libusb support"
		exit 1
	fi
fi

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install

if [ `uname -s` == "Linux" ] || [ `uname -s` == "Darwin" ]
then
	cd ../objdir/bin/
	mv avrdude avrdude_bin
	cp ../../avrdude-files/avrdude .
	if [ `uname -s` == "Darwin" ]
	then
		sed -i '' 's/LD_LIBRARY_PATH/DYLD_LIBRARY_PATH/g' avrdude
	fi
fi
