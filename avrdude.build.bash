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

mkdir -p avrdude-build
cd avrdude-build

CONFARGS=" \
	--prefix=$PREFIX \
	--enable-linuxgpio \
	--enable-arduinotre"

CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../avrdude-6.0.1/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install

