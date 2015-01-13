#!/bin/bash -ex

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

if [[ `uname -s` == CYGWIN* || `uname -s` == MINGW* ]]
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

	mkdir -p $PREFIX/bin
	cp $LIBUSB_DIR/bin/x86/libusb0_x86.dll $PREFIX/bin/libusb0.dll
fi

if [ `uname -s` == "Linux" ] || [ `uname -s` == "Darwin" ]
then
	if [[ ! -f libusb-1.0.18.tar.bz2  ]] ;
	then
		wget http://switch.dl.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.18/libusb-1.0.18.tar.bz2
	fi

	tar xfv libusb-1.0.18.tar.bz2

	mkdir -p libusb-1.0-build
	cd libusb-1.0-build

	CONFARGS=" \
		--prefix=$PREFIX \
		--disable-udev \
		--enable-static \
		--enable-shared"

	CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../libusb-1.0.18/configure $CONFARGS

	if [ -z "$MAKE_JOBS" ]; then
		MAKE_JOBS="2"
	fi

	nice -n 10 make -j $MAKE_JOBS

	make install

	cd ..

	if [[ ! -f libusb-compat-0.1.5.tar.bz2  ]] ;
	then
		wget http://switch.dl.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2
	fi

	tar xfv libusb-compat-0.1.5.tar.bz2

	mkdir -p libusb-0.1-build
	cd libusb-0.1-build

	CONFARGS=" \
		--prefix=$PREFIX \
		--enable-static \
		--enable-shared"

	PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig" CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../libusb-compat-0.1.5/configure $CONFARGS

	if [ -z "$MAKE_JOBS" ]; then
		MAKE_JOBS="2"
	fi

	nice -n 10 make -j $MAKE_JOBS

	make install
fi
