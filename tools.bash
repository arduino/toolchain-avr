#!/bin/bash -ex

mkdir -p toolsdir/bin
cd toolsdir
TOOLS_PATH=`pwd`
cd bin
TOOLS_BIN_PATH=`pwd`
cd ../../

export PATH="$TOOLS_BIN_PATH:$PATH"

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

if [[ ! -f autoconf-2.64.tar.bz2  ]] ;
then
	wget http://mirror.switch.ch/ftp/mirror/gnu/autoconf/autoconf-2.64.tar.bz2
fi

tar xfjv autoconf-2.64.tar.bz2

cd autoconf-2.64

CONFARGS="--prefix=$TOOLS_PATH"

./configure $CONFARGS

nice -n 10 make -j $MAKE_JOBS

make install

cd -

if [[ ! -f automake-1.11.1.tar.bz2  ]] ;
then
	wget http://mirror.switch.ch/ftp/mirror/gnu/automake/automake-1.11.1.tar.bz2
fi

tar xfjv automake-1.11.1.tar.bz2

cd automake-1.11.1

./bootstrap

CONFARGS="--prefix=$TOOLS_PATH"

./configure $CONFARGS

nice -n 10 make -j $MAKE_JOBS

make install

cd -

