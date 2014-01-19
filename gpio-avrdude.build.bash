#!/bin/bash -ex

if [[ ! -d gpio-avrdude-1138 ]] ;
then
	svn co http://svn.savannah.nongnu.org/svn/avrdude/trunk/avrdude@1138 gpio-avrdude-1138
fi

cd gpio-avrdude-1138
for p in ../gpio-avrdude-patches/*.patch; do echo Applying $p; patch -p0 < $p; done
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p gpio-avrdude-build
cd gpio-avrdude-build

CONFARGS=" \
	--prefix=$PREFIX \
        --enable-linuxgpio \
        --program-prefix=gpio-"

CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../gpio-avrdude-1138/configure $CONFARGS

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

if [ `uname -s` == "Darwin" ]
then
	SED_CMD="sed -i ''"
else
	SED_CMD="sed -i"
fi

mv avrdude.conf gpio-avrdude.conf
$SED_CMD 's/sysconf_DATA = avrdude.conf/sysconf_DATA = gpio-avrdude.conf/g' Makefile
$SED_CMD 's|@if test -e ${DESTDIR}${sysconfdir}/avrdude.conf; then|@if test -e ${DESTDIR}${sysconfdir}/gpio-avrdude.conf; then|g' Makefile
$SED_CMD 's|cp -pR ${DESTDIR}${sysconfdir}/avrdude.conf|cp -pR ${DESTDIR}${sysconfdir}/gpio-avrdude.conf|g' Makefile
$SED_CMD 's|${DESTDIR}${sysconfdir}/avrdude.conf.bak|${DESTDIR}${sysconfdir}/gpio-avrdude.conf.bak|g' Makefile
$SED_CMD 's/rm -f avrdude.conf/rm -f gpio-avrdude.conf/g' Makefile

make install

