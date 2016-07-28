#!/usr/bin/env bash
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

set -ex

mkdir -p toolsdir/bin
cd toolsdir
TOOLS_PATH=`pwd`
cd bin
TOOLS_BIN_PATH=`pwd`
cd ../../

export PATH="$TOOLS_BIN_PATH:$PATH"
MAKE=make

if [ `uname -s` == "FreeBSD" ] ;
then
	MAKE=gmake
fi

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

nice -n 10 $MAKE -j $MAKE_JOBS

$MAKE install

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

nice -n 10 $MAKE -j $MAKE_JOBS

$MAKE install

cd -

