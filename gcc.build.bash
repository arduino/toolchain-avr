#!/bin/bash -ex
# Copyright (c) 2014-2015 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

source build.conf

if [[ ! -d toolsdir  ]] ;
then
	echo "You must first build the tools: run build_tools.bash"
	exit 1
fi

cd toolsdir/bin
TOOLS_BIN_PATH=`pwd`
cd -

export PATH="$TOOLS_BIN_PATH:$PATH"

if [[ ! -f gmp-${GMP_VERSION}.tar.bz2  ]] ;
then
	wget ${GMP_SOURCE}
fi

tar xfv gmp-${GMP_VERSION}.tar.bz2

if [[ ! -f mpfr-${MPFR_VERSION}.tar.bz2  ]] ;
then
	wget ${MPFR_SOURCE}
fi

tar xfv mpfr-${MPFR_VERSION}.tar.bz2

if [[ ! -f mpc-${MPC_VERSION}.tar.gz  ]] ;
then
	wget ${MPC_SOURCE}
fi

tar xfv mpc-${MPC_VERSION}.tar.gz

if [[ ! -f avr-gcc.tar.bz2 ]] ;
then
	wget $AVR_SOURCES/avr-gcc.tar.bz2
fi

tar xfv avr-gcc.tar.bz2

pushd gcc
#pushd gcc/config/avr/
#sh genopt.sh avr-mcus.def > avr-tables.opt
#cat avr-mcus.def | awk -f genmultilib.awk FORMAT="Makefile" > t-multilib 
#popd
pushd gcc
for p in ../../avr-gcc-patches/*.patch
do
	echo Applying $p
	patch -p1 < $p
done
autoconf
popd
popd

mv gmp-5.0.2 gcc/gmp
mv mpfr-3.0.0 gcc/mpfr
mv mpc-0.9 gcc/mpc

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p gcc-build
cd gcc-build

CONFARGS=" \
	--enable-fixed-point \
	--enable-languages=c,c++ \
	--prefix=$PREFIX \
	--enable-long-long \
	--disable-nls \
	--disable-checking \
	--disable-libssp \
        --disable-libada \
	--disable-shared \
	--enable-lto \
        --with-avrlibc=yes \
	--with-dwarf2 \
        --disable-doc \
	--target=avr"

if [ `uname -s` == "Darwin" ]
then
	# Use default system libraries (no other Macports libraries)
	LDFLAGS="$LDFLAGS -L/usr/lib"
fi

CFLAGS="-w -O2 -g0 $CFLAGS" CXXFLAGS="-w -O2 -g0 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../gcc/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install

