#!/bin/bash -ex

if [[ ! -f avrdude-5.11.1.tar.gz  ]] ;
then
	wget http://download.savannah.gnu.org/releases/avrdude/avrdude-5.11.1.tar.gz
fi

tar xfzv avrdude-5.11.1.tar.gz

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p avrdude-build
cd avrdude-build

CONFARGS=" \
	--prefix=$PREFIX"

CFLAGS="-w $CFLAGS" CXXFLAGS="-w $CXXFLAGS" ../avrdude-5.11.1/configure $CONFARGS

if [ -n "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install 

