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

if [[ ! -f avr-libc-1.8.0.tar.bz2 ]] ;
then
	wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.8.0.tar.bz2
fi

tar xfjv avr-libc-1.8.0.tar.bz2

cd avr-libc-1.8.0
for p in ../avr-libc-patches/*.patch; do echo Applying $p; patch -p1 < $p; done
cd -

if [[ ! -f avr8-headers-6.2.0.142.zip ]] ;
then
	wget http://distribute.atmel.no/tools/opensource/Atmel-AVR-GNU-Toolchain/3.4.3/avr8-headers-6.2.0.142.zip
fi

unzip avr8-headers-6.2.0.142.zip
mv avr avr8-headers-6.2.0.142

for i in avr8-headers-6.2.0.142/io[0-9a-zA-Z]*.h
do
	cp -v -f $i avr-libc-1.8.0/include/avr/
done

cd avr-libc-1.8.0
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p avr-libc-build
cd avr-libc-build

CONFARGS=" \
	--prefix=$PREFIX \
	--host=avr \
	--disable-doc"

PATH=$PREFIX/bin:$PATH CC="avr-gcc" CXX="avr-g++" CFLAGS="-w -Os $CFLAGS" CXXFLAGS="-w -Os $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../avr-libc-1.8.0/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

PATH=$PREFIX/bin:$PATH nice -n 10 make -j $MAKE_JOBS

PATH=$PREFIX/bin:$PATH make install

