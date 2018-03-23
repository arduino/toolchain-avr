## AVR Toolchain for Arduino

This is the AVR Toolchain used in the [Arduino IDE](http://arduino.cc/).

As soon as Atmel [ships a newer toolchain](http://distribute.atmel.no/tools/opensource/Atmel-AVR-GNU-Toolchain/), we pull the source code, **patch it** with some user contributed patches and deliver it with the [Arduino IDE](http://arduino.cc/).
Therefore, the resulting binaries may differ significantly from Atmel's. And you should start blaming us if things are not working as expected :)

### Configuring

Edit the `build.conf` file, currently the only thing worth changing is `AVR_VERSION` on the first line to match whatever the [latest version is](http://distribute.atmel.no/tools/opensource/Atmel-AVR-GNU-Toolchain/).

At time of writing, the latest toolchain available is based on Atmel 3.5.4 version. It contains:
 - binutils-2.26
 - gcc-4.9.2
 - avr-libc-2.0.0
 - gdb-7.8
 
### Building

Setup has been done on partially set up development machines. If, trying to compile on your machine, you find any package missing from the following list, please open an issue at once! We all can't afford wasting time on setup :)

To just build, after getting the requirements...
```bash
./tools.bash
./binutils.build.bash
./gcc.build.bash
./avr-libc.build.bash
./gdb.build.bash
```
after a successful compile the binaries etc will be found in `objdir`

To package, after getting the requirements...
```bash
./package-avr-gcc.bash
```

#### Debian requirements

```bash
sudo apt-get install build-essential gperf bison subversion texinfo zip automake flex libtinfo-dev pkg-config wget
```

#### Mac OSX requirements

You need to install MacPorts: https://www.macports.org/install.php. Once done, open a terminal and type:

```bash
sudo port selfupdate
sudo port upgrade outdated
sudo port install wget +universal
sudo port install automake +universal
sudo port install autoconf +universal
sudo port install gpatch +universal
sudo port install gsed +universal
```

#### Windows requirements

You need to install Cygwin: http://www.cygwin.com/. Once you have run `setup-x86.exe`, use the `Search` text field to filter and select for installation the following packages:

- git
- wget
- unzip
- zip
- gperf
- bison
- flex
- make
- patch
- automake
- autoconf
- gcc-g++
- texinfo (must be at version 4.13 since 5+ won't work)
- libncurses-devel

A note on texinfo: due to dependencies, each time you update/modify your cygwin installation (for example: you install an additional package), texinfo will be upgraded to version 5+, while you need version 4+!
Easy solution: as soon as you've installed the additional package, re-run cygwin setup, search texinfo, triple click on "Keep" until you read version 4, then click next.

You also need to install MinGW: http://www.mingw.org/. Once you have run mingw-get-setup.exe, select and install (clicking on "Installation" -> "Apply changes") the following packages:

- mingw-developer-toolkit
- mingw32-base
- mingw32-gcc-g++
- msys-base
- msys-zip

### Upstream credits

Build process ported from Debian. Most patches come from Atmel. Thank you guys for your awesome work.

### Credits

Consult the [list of contributors](https://github.com/arduino/toolchain-avr/graphs/contributors).

### License

The bash scripts are GPLv2 licensed. Every other software used by these bash scripts has its own license. Consult them to know the terms.

