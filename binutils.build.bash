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

if [[ ! -f binutils-2.23.2.tar.bz2  ]] ;
then
	wget http://mirror.switch.ch/ftp/mirror/gnu/binutils/binutils-2.23.2.tar.bz2
fi

tar xfjv binutils-2.23.2.tar.bz2

cd binutils-2.23.2
for p in ../binutils-patches/*.patch; do echo Applying $p; patch -p0 < $p; done
autoconf
cd ld
autoreconf
cd ../../

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
	--disable-doc \
	--disable-werror \
	--enable-install-libiberty \
	--enable-install-libbfd \
	--target=avr"

CFLAGS="-w -O2 -g0 $CFLAGS" CXXFLAGS="-w -O2 -g0 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../binutils-2.23.2/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS all-bfd TARGET-bfd=headers
rm bfd/Makefile
nice -n 10 make -j $MAKE_JOBS configure-host
nice -n 10 make -j $MAKE_JOBS all

make install

