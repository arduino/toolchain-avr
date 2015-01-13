#!/bin/bash -ex

if [[ ! -d toolsdir  ]] ;
then
	echo "You must first build the tools: run build_tools.bash"
	exit 1
fi

cd toolsdir/bin
TOOLS_BIN_PATH=`pwd`
cd -

export PATH="$TOOLS_BIN_PATH:$PATH"

if [[ ! -f avrdude-6.0.1.tar.gz  ]] ;
then
	wget http://download.savannah.gnu.org/releases/avrdude/avrdude-6.0.1.tar.gz
fi

tar xfv avrdude-6.0.1.tar.gz

cd avrdude-6.0.1
for p in ../avrdude-patches/*.patch; do echo Applying $p; patch -p0 < $p; done
if [[ `uname -s` != CYGWIN* && `uname -s` != MINGW* ]]
then
	for p in ../avrdude-patches/*.patch.optional; do echo Applying $p; patch -p0 < $p; done
fi
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
	CFLAGS="$CFLAGS -I$PREFIX/include -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
	CXXFLAGS="$CXXFLAGS -I$PREFIX/include -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
	LDFLAGS="$LDFLAGS -I$PREFIX/include -I$PREFIX/include -L$PREFIX/lib"
fi

mkdir -p avrdude-build
cd avrdude-build

CONFARGS=" \
	--prefix=$PREFIX \
	--enable-linuxgpio"

if [[ `uname -s` != CYGWIN* && `uname -s` != MINGW* ]]
then
	CONFARGS="$CONFARGS \
		--enable-arduinotre"
fi

CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../avrdude-6.0.1/configure $CONFARGS

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
