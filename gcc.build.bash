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

if [ `uname -s` == "Darwin" ]
then
   # On Mac OS X install wget, libgmp, libmpfr and libmpc using Macports:
   #
   #   sudo port install gmp
   #   sudo port install mpfr
   #   sudo port install mpc
   #
   CONFARGS=$CONFARGS" \
	--with-gmp=/opt/local \
	--with-mpfr=/opt/local \
	--with-mpc=/opt/local"

   # Use default system libraries (no other Macports libraries)
   LDFLAGS=-L/usr/lib
fi

CFLAGS=-w CXXFLAGS=-w LDFLAGS="$LDFLAGS" ../gcc-4.3.2/configure $CONFARGS

nice -n 10 make -j 5

make install 

