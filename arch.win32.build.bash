#!/bin/bash -ex

export PATH=/cygdrive/c/cygwin/bin:$PATH
CFLAGS="-DWIN32" CXXFLAGS="-DWIN32" LDFLAGS="-DWIN32" CC="gcc -m32" CXX="g++ -m32" ./build.all.bash

