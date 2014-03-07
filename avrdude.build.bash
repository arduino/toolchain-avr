#!/bin/bash -ex

if [[ ! -f avrdude-6.0.1.tar.gz  ]] ;
then
	wget http://download.savannah.gnu.org/releases/avrdude/avrdude-6.0.1.tar.gz
fi

tar xfzv avrdude-6.0.1.tar.gz

cd avrdude-6.0.1
for p in ../avrdude-patches/*.patch; do echo Applying $p; patch -p0 < $p; done
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

if [[ `uname -s` == CYGWIN* ]]
then
	cd tmp/libusb-win32-bin*
	LIBUSB_DIR=`pwd`
	cd ../..

	CFLAGS="$CFLAGS -I$LIBUSB_DIR/include -L$LIBUSB_DIR/lib/gcc"
	CXXFLAGS="$CXXFLAGS -I$LIBUSB_DIR/include -L$LIBUSB_DIR/lib/gcc"
	LDFLAGS="$LDFLAGS -I$LIBUSB_DIR/include -L$LIBUSB_DIR/lib/gcc"
fi

if [ `uname -s` == "Darwin" ]
then
	CFLAGS="$CFLAGS -I/opt/local/include/libusb-1.0/ -L/opt/local/lib"
	CXXFLAGS="$CXXFLAGS -I/opt/local/include/libusb-1.0/ -L/opt/local/lib"
fi

if [ `uname -s` == "Linux" ]
then
	CFLAGS="$CFLAGS -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
	CXXFLAGS="$CXXFLAGS -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
	LDFLAGS="$LDFLAGS -I$PREFIX/include -L$PREFIX/lib"
fi

mkdir -p avrdude-build
cd avrdude-build

CONFARGS=" \
	--prefix=$PREFIX \
	--enable-linuxgpio"

CFLAGS="-w -O2 -DHAVE_LINUX_GPIO $CFLAGS" CXXFLAGS="-w -O2 -DHAVE_LINUX_GPIO $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../avrdude-6.0.1/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install

