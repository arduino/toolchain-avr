#!/bin/bash -e

if [[ ! -f avrdude-5.11.1.tar.gz  ]] ;
then
	wget http://download.savannah.gnu.org/releases/avrdude/avrdude-5.11.1.tar.gz
fi

tar xfjv avrdude-5.11.1.tar.gz

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p avrdude-build
cd avrdude-build

CONFARGS=" \
	--prefix=$PREFIX"

CFLAGS=-w CXXFLAGS=-w ../avrdude-5.11.1/configure $CONFARGS

nice -n 10 make -j 5

make install 

