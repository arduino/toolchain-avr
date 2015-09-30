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

./build.all.bash

rm -f *arduino*.tar.bz2 *arduino*.zip

tar -cjvf ./avr-gcc-4.9.2-arduino1-armhf-pc-linux-gnu.tar.bz2 avr/

tar -cjvf ./avrdude-6.1-arduino1-armhf-pc-linux-gnu.tar.bz2 avrdude-6.1/

