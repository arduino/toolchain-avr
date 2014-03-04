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
	if [[ ! -f libusb-win32-bin-1.2.6.0.zip  ]] ;
	then
		wget http://switch.dl.sourceforge.net/project/libusb-win32/libusb-win32-releases/1.2.6.0/libusb-win32-bin-1.2.6.0.zip
	fi

	mkdir -p tmp
	rm -rf tmp/libusb-win32-bin*
	cd tmp
	unzip ../libusb-win32-bin-1.2.6.0.zip
	cd libusb-win32-bin*
	LIBUSB_DIR=`pwd`
	cd ../..

	CFLAGS="$CFLAGS -I$LIBUSB_DIR/include -L$LIBUSB_DIR/lib/gcc"
	CXXFLAGS="$CXXFLAGS -I$LIBUSB_DIR/include -L$LIBUSB_DIR/lib/gcc"
	LDFLAGS="$LDFLAGS -I$LIBUSB_DIR/include -L$LIBUSB_DIR/lib/gcc"

	mkdir -p $PREFIX/bin
	cp $LIBUSB_DIR/bin/x86/libusb0_x86.dll $PREFIX/bin/libusb0.dll
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

