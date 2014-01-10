#!/bin/sh -ex

if [[ ! -f binutils-2.20.1a.tar.bz2  ]] ;
then
	wget ftp://ftp.fu-berlin.de/unix/gnu/binutils/binutils-2.20.1a.tar.bz2
fi

tar xfjv binutils-2.20.1a.tar.bz2

cd binutils-2.20.1
for p in `cat ../binutils-debian/patchlist`; do echo; echo Applying $p ...; patch -p0 < ../binutils-debian/$p; done
cd -

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
	--disable-shared \
	--with-dwarf2 \
	--target=avr"

CFLAGS="-w $CFLAGS" CXXFLAGS="-w $CXXFLAGS" ../binutils-2.20.1/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install 

