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

if [[ ! -f gmp-5.0.2.tar.bz2  ]] ;
then
	wget http://mirror.switch.ch/ftp/mirror/gnu/gmp/gmp-5.0.2.tar.bz2
fi

tar xfv gmp-5.0.2.tar.bz2

if [[ ! -f mpfr-3.0.0.tar.bz2  ]] ;
then
	wget http://mirror.switch.ch/ftp/mirror/gnu/mpfr/mpfr-3.0.0.tar.bz2
fi

tar xfv mpfr-3.0.0.tar.bz2

if [[ ! -f mpc-0.9.tar.gz  ]] ;
then
	wget http://www.multiprecision.org/mpc/download/mpc-0.9.tar.gz
fi

tar xfv mpc-0.9.tar.gz

if [[ ! -f gcc-4.8.1.tar.bz2 ]] ;
then
	wget http://mirror.switch.ch/ftp/mirror/gnu/gcc/gcc-4.8.1/gcc-4.8.1.tar.bz2
fi

tar xfv gcc-4.8.1.tar.bz2

pushd gcc-4.8.1
for p in ../gcc-patches/*.patch; do echo Applying $p; patch -p1 < $p; done
pushd gcc/config/avr/
sh genopt.sh avr-mcus.def > avr-tables.opt
cat avr-mcus.def | awk -f genmultilib.awk FORMAT="Makefile" > t-multilib 
popd
pushd gcc
autoconf
popd
popd

mv gmp-5.0.2 gcc-4.8.1/gmp
mv mpfr-3.0.0 gcc-4.8.1/mpfr
mv mpc-0.9 gcc-4.8.1/mpc

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
        --with-avrlibc=yes \
	--with-dwarf2 \
        --disable-doc \
	--target=avr"

if [ `uname -s` == "Darwin" ]
then
	# Use default system libraries (no other Macports libraries)
	LDFLAGS="$LDFLAGS -L/usr/lib"
fi

CFLAGS="-w -O2 -g0 $CFLAGS" CXXFLAGS="-w -O2 -g0 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../gcc-4.8.1/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install

