#!/usr/bin/env bash
# Copyright (c) 2014-2016 Arduino LLC
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

set -ex

OUTPUT_VERSION=4.9.2-atmel3.5.3-arduino2

export OS=`uname -o || uname`
export TARGET_OS=$OS

if [[ $CROSS_COMPILE == "mingw" ]] ; then

  export CC="i686-w64-mingw32-gcc"
  export CXX="i686-w64-mingw32-g++"
  export CROSS_COMPILE_HOST="i686-w64-mingw32"
  export TARGET_OS="Windows"
  OUTPUT_TAG=i686-w64-mingw32

elif [[ $OS == "GNU/Linux" ]] ; then

  export MACHINE=`uname -m`
  if [[ $MACHINE == "x86_64" ]] ; then
    OUTPUT_TAG=x86_64-pc-linux-gnu
  elif [[ $MACHINE == "i686" ]] ; then
    OUTPUT_TAG=i686-pc-linux-gnu
  elif [[ $MACHINE == "armv7l" ]] ; then
    OUTPUT_TAG=armhf-pc-linux-gnu
  else
    echo Linux Machine not supported: $MACHINE
    exit 1
  fi

elif [[ $OS == "Msys" || $OS == "Cygwin" ]] ; then

  export PATH=$PATH:/c/MinGW/bin/:/c/cygwin/bin/
  export CC="mingw32-gcc -m32"
  export CXX="mingw32-g++ -m32"
  export CFLAGS="-DWIN32"
  export CXXFLAGS="-DWIN32"
  export LDFLAGS="-DWIN32"
  export MAKE_JOBS=1
  OUTPUT_TAG=i686-mingw32

elif [[ $OS == "Darwin" ]] ; then

  export PATH=/opt/local/libexec/gnubin/:/opt/local/bin:$PATH
  export CC="gcc -arch i386 -mmacosx-version-min=10.5"
  export CXX="g++ -arch i386 -mmacosx-version-min=10.5"
  OUTPUT_TAG=i386-apple-darwin11

elif [[ $OS == "FreeBSD" ]] ; then

  export MACHINE=`uname -m` 

else

  echo OS Not supported: $OS
  exit 2

fi

rm -rf autoconf-2.64 automake-1.11.1
rm -rf gcc gmp-5.0.2 mpc-0.9 mpfr-3.0.0 binutils avr-libc libc avr8-headers gdb
rm -rf toolsdir objdir *-build

./tools.bash
./binutils.build.bash
./gcc.build.bash
./avr-libc.build.bash
./gdb.build.bash

rm -rf objdir/{info,man,share}

# if producing a windows build, compress as zip and
# copy *toolchain-precompiled* content to any folder containing a .exe
if [[ ${OUTPUT_TAG} == *"mingw"* ]] ; then

  rm -f avr-gcc-${OUTPUT_VERSION}-${OUTPUT_TAG}.zip
  mv objdir avr
  BINARY_FOLDERS=`find avr -name *.exe -print0 | xargs -0 -n1 dirname | sort --unique`
  echo $BINARY_FOLDERS | xargs -n1 cp toolchain-precompiled/*
  zip -r avr-gcc-${OUTPUT_VERSION}-${OUTPUT_TAG}.zip avr
  mv avr objdir

else

  rm -f avr-gcc-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2
  mv objdir avr
  tar -cjvf avr-gcc-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2 avr
  mv avr objdir

fi
