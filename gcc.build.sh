#!/bin/sh -ex

if [[ ! -f gmp-4.3.2.tar.bz2  ]] ;
then
	wget ftp://ftp.fu-berlin.de/unix/languages/gcc/infrastructure/gmp-4.3.2.tar.bz2
fi

tar xfjv gmp-4.3.2.tar.bz2

if [[ ! -f mpfr-2.4.2.tar.bz2  ]] ;
then
	wget ftp://ftp.fu-berlin.de/unix/languages/gcc/infrastructure/mpfr-2.4.2.tar.bz2
fi

tar xfjv mpfr-2.4.2.tar.bz2

if [[ ! -f mpc-0.8.1.tar.gz  ]] ;
then
	wget ftp://ftp.fu-berlin.de/unix/languages/gcc/infrastructure/mpc-0.8.1.tar.gz
fi

tar xfzv mpc-0.8.1.tar.gz

if [[ ! -f gcc-4.3.2.tar.bz2 ]] ;
then
	wget ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-4.3.2/gcc-4.3.2.tar.bz2
fi

tar xfjv gcc-4.3.2.tar.bz2

cd gcc-4.3.2
for p in ../gcc-debian/patches/*.patch; do echo Applying $p; patch -p0 < $p; done
cd -

mv gmp-4.3.2 gcc-4.3.2/gmp
mv mpfr-2.4.2 gcc-4.3.2/mpfr
mv mpc-0.8.1 gcc-4.3.2/mpc

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
	# Use default system libraries (no other Macports libraries)
	LDFLAGS="$LDFLAGS -L/usr/lib"
fi

CFLAGS="-w $CFLAGS" CXXFLAGS="-w $CXXFLAGS" LDFLAGS="$LDFLAGS" ../gcc-4.3.2/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install 

