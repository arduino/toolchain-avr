#!/bin/bash -e

if [[ ! -f gcc-4.3.2.tar.bz2 ]] ;
then
	wget ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-4.3.2/gcc-4.3.2.tar.bz2
fi

tar xfjv gcc-4.3.2.tar.bz2

cd gcc-4.3.2
for p in ../gcc-debian/patches/*.patch; do echo Applying $p; patch -p0 < $p; done
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p gcc-build
cd gcc-build

CONFARGS=" \
	--enable-languages=c,c++ \
	--prefix=$PREFIX \
	--enable-long-long \
	--disable-nls \
	--disable-checking \
	--disable-libssp \
	--disable-shared \
	--with-dwarf2 \
	--target=avr"

CFLAGS=-w CXXFLAGS=-w ../gcc-4.3.2/configure $CONFARGS

nice -n 10 make -j 5

make install 

