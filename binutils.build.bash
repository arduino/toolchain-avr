#!/bin/bash -ex

if [[ ! -f binutils-2.20.1a.tar.bz2  ]] ;
then
	wget ftp://gcc.gnu.org/pub/binutils/releases/binutils-2.20.1a.tar.bz2
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

nice -n 10 make -j 5

make install 

