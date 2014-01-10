#!/bin/bash -ex

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
	CONFARGS="$CONFARGS \
		--with-gmp=/opt/local \
		--with-mpfr=/opt/local \
		--with-mpc=/opt/local"

	# Use default system libraries (no other Macports libraries)
	LDFLAGS="$LDFLAGS -L/usr/lib"
fi

CFLAGS="-w $CFLAGS" CXXFLAGS="-w $CXXFLAGS" LDFLAGS="$LDFLAGS" ../gcc-4.3.2/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

CFLAGS="-w $CFLAGS" CXXFLAGS="-w $CXXFLAGS" LDFLAGS="$LDFLAGS" nice -n 10 make -j $MAKE_JOBS

make install 

