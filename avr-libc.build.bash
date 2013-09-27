#!/bin/bash -e

if [[ ! -f avr-libc-1.6.4.tar.bz2 ]] ;
then
	wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.6.4.tar.bz2
fi

tar xfjv avr-libc-1.6.4.tar.bz2

cp avr-libc-patches/eeprom.h avr-libc-1.6.4/include/avr/eeprom.h

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p avr-libc-build
cd avr-libc-build

CONFARGS=" \
        --prefix=$PREFIX \
        --host=avr"

PATH=$PREFIX/bin:$PATH CFLAGS=-w CXXFLAGS=-w ../avr-libc-1.6.4/configure $CONFARGS

PATH=$PREFIX/bin:$PATH nice -n 10 make -j 5

PATH=$PREFIX/bin:$PATH make install 

