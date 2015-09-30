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

rm -rf autoconf-2.64 automake-1.11.1

rm -rf gcc-4.9.2 gmp-5.0.2 mpc-0.9 mpfr-3.0.0 binutils-2.25 avr-libc-1.8.0 avr8-headers avrdude-6.1 libusb-1.0.20 libusb-compat-0.1.5 gdb-7.8 *-build

rm -rf objdir/{info,man,share}

