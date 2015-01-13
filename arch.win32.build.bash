#!/bin/bash -ex

export PATH=$PATH:/c/MinGW/bin/:/c/cygwin/bin/
CFLAGS="-DWIN32" CXXFLAGS="-DWIN32" LDFLAGS="-DWIN32" CC="mingw32-gcc -m32" CXX="mingw32-g++ -m32" ./build.all.bash

rm -f avr-toolchain-*.zip
cd objdir
for folder in avr/bin bin libexec/gcc/avr/4.8.1/
do
	cp /c/MinGW/bin/libiconv-2.dll $folder
done
zip -r -9 ../avr-toolchain-win32-3.4.5.zip .

