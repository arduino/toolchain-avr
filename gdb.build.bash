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

if [[ ! -f gdb-7.8.tar.xz  ]] ;
then
	wget http://mirror.switch.ch/ftp/mirror/gnu/gdb/gdb-7.8.tar.xz
fi

tar xfv gdb-7.8.tar.xz

cd gdb-7.8
for p in ../gdb-patches/*.patch; do echo Applying $p; patch --binary -p1 < $p; done
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p gdb-build
cd gdb-build

CONFARGS=" \
	--prefix=$PREFIX \
	--disable-nls \
	--disable-werror \
	--disable-binutils \
	--target=avr"

CFLAGS="-w -O2 -g0 $CFLAGS" CXXFLAGS="-w -O2 -g0 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../gdb-7.8/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install

