#!/bin/bash -ex
# Copyright (c) 2017 Arduino LLC
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

wget ${ATMEL_DX_PACK_URL}

mkdir -p atpack
cd atpack
rm -rf *
mv ../${ATMEL_DX_PACK_FILENAME}.atpack .

mv ${ATMEL_DX_PACK_FILENAME}.atpack ${ATMEL_DX_PACK_FILENAME}.zip
unzip ${ATMEL_DX_PACK_FILENAME}.zip

ALL_FILES=`find ../objdir`

#copy relevant files to the right folders
# 1- copy includes definitions
EXTRA_INCLUDES=`diff -q ../objdir/avr/include/avr ../atpack/include/avr | grep "Only in" | grep atpack | cut -f4 -d" "`
for x in $EXTRA_INCLUDES; do
  cp include/avr/${x} ../objdir/avr/include/avr
done

# 2 - compact specs into a single folder
SPECS_FOLDERS=`ls gcc/dev`
mkdir temp
for folder in $SPECS_FOLDERS; do
  cp -r gcc/dev/${folder}/* temp/
done

# 3 - find different files (device-specs)
EXTRA_SPECS=`diff -q ../objdir/lib/gcc/avr/${GCC_VERSION}/device-specs/ temp/device-specs | grep "Only in" | grep temp | cut -f4 -d" "`
for x in $EXTRA_SPECS; do
  cp temp/device-specs/${x} ../objdir/lib/gcc/avr/${GCC_VERSION}/device-specs/
done

#since https://github.com/gcc-mirror/gcc/commit/21a6b87b86defda10ac903a9cd49e34b1f8ce6fb a lot of devices has specs but avr-libc doesn't support them yet
ALL_DEVICE_SPECS=`ls temp/device-specs`
rm -rf temp/device-specs

EXTRA_LIBS=`diff -r -q ../objdir/avr/lib temp/ | grep "Only in" | grep temp | cut -f4 -d" "`
for x in $EXTRA_LIBS; do
  if [ ! -d temp/${x} ]; then
  cd temp
  LOCATION=`find . | grep ${x}`
  cd ..
  else
  LOCATION=${x}
  fi
  cp -r temp/${LOCATION} ../objdir/avr/lib/${LOCATION}
done

# 4 - extract the correct includes and add them to io.h
# ARGH! difficult!
echo "STARTING THE MAGIC"
for x in $ALL_DEVICE_SPECS; do
  DEFINITION=`cat ../objdir/lib/gcc/avr/${GCC_VERSION}/device-specs/${x} | grep __AVR_DEVICE_NAME__ | cut -f 1 -d " " | cut -b 4-`
  FANCY_NAME=`cat ../objdir/lib/gcc/avr/${GCC_VERSION}/device-specs/${x} | grep __AVR_DEVICE_NAME__ | cut -f2 -d"="`
  echo $DEFINITION
  echo $FANCY_NAME
  LOWERCASE_DEFINITION="${DEFINITION,,}"
  echo $LOWERCASE_DEFINITION
  HEADER_TEMP="${LOWERCASE_DEFINITION#__avr_}"
  echo $HEADER_TEMP
  HEADER="${HEADER_TEMP%__}"
  echo $HEADER
  _DEFINITION="#elif defined (${DEFINITION})"
  echo $__DEFINITION
  _HEADER="#  include <avr/io${HEADER}.h>"
  echo $__HEADER
  if [ "$(grep -c "${DEFINITION}" ../objdir/avr/include/avr/io.h)" == 0 ]; then
    NEWFILE=`awk '/iom3000.h/ { print; print "____DEFINITION____"; print "____HEADER____"; next }1' ../objdir/avr/include/avr/io.h | sed "s/____DEFINITION____/$_DEFINITION/g" |  sed "s@____HEADER____@$_HEADER@g"`
    echo $NEWFILE
    echo "$NEWFILE" > ../objdir/avr/include/avr/io.h
  fi
done
echo "ENDING THE MAGIC"
#NEW_ALL_FILES=`find ../objdir`

#echo "NEW FILES ADDED: "
#diff  <(echo "$ALL_FILES" ) <(echo "$NEW_ALL_FILES")

cd ..

