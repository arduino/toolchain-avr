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

if [[ ! -f autoconf-${AUTOCONF_VERSION}.tar.bz2  ]] ;
then
	wget $AUTOCONF_SOURCE
fi

tar xfjv autoconf-${AUTOCONF_VERSION}.tar.bz2

cd autoconf-${AUTOCONF_VERSION}

CONFARGS="--prefix=$TOOLS_PATH"

./configure $CONFARGS

nice -n 10 make -j $MAKE_JOBS

make install

cd -

if [[ ! -f automake-${AUTOMAKE_VERSION}.tar.bz2  ]] ;
then
	wget $AUTOMAKE_SOURCE
fi

tar xfjv automake-${AUTOMAKE_VERSION}.tar.bz2

cd automake-${AUTOMAKE_VERSION}

patch -p1 < ../automake-patches/0001-fix-perl-522.patch

cp ../config.guess-am-1.11.4 lib/config.guess
./bootstrap

CONFARGS="--prefix=$TOOLS_PATH"

./configure $CONFARGS

# Prevent compilation problem with docs complaining about @itemx not following @item
cp doc/automake.texi doc/automake.texi2
cat doc/automake.texi2 | $SED -r 's/@itemx/@c @itemx/' >doc/automake.texi
rm doc/automake.texi2

nice -n 10 make -j $MAKE_JOBS

make install

cd -

