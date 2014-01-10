#!/bin/bash -ex

if [[ ! -f avr-libc-1.6.4.tar.bz2 ]] ;
then
	wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.6.4.tar.bz2
fi

tar xfjv avr-libc-1.6.4.tar.bz2

cd avr-libc-1.6.4
for p in ../avr-libc-patches/*.patch; do echo Applying $p; patch -p0 < $p; done
cd -

cp avr-libc-patches/eeprom.h avr-libc-1.6.4/include/avr/eeprom.h

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p avr-libc-build
cd avr-libc-build

CONFARGS=" \
	--prefix=$PREFIX \
	--host=avr"

PATH=$PREFIX/bin:$PATH CFLAGS="-w $CFLAGS" CXXFLAGS="-w $CXXFLAGS" LDFLAGS="$LDFLAGS" ../avr-libc-1.6.4/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

PATH=$PREFIX/bin:$PATH CFLAGS="-w $CFLAGS" CXXFLAGS="-w $CXXFLAGS" LDFLAGS="$LDFLAGS" nice -n 10 make -j $MAKE_JOBS

PATH=$PREFIX/bin:$PATH make install 

