Note: setup has been done on partially set up development machines. If, trying to compile on your machine, you find any package missing from the following list, please open an issue at once! We all can't afford wasting time on setup :)

### Debian requirements

```bash
sudo apt-get install build-essential gperf bison subversion texinfo zip automake flex libusb-dev libusb-1.0-0-dev
```

### Mac OSX requirements

```bash
sudo port selfupdate
sudo port upgrade outdated
sudo port install wget +universal
sudo port install automake +universal
sudo port install autoconf +universal
sudo port install gpatch +universal
sudo port install libusb +universal
```

### Windows requirements

[Cygwin](http://www.cygwin.com/) installed with all the development tools including 
- git
- wget
- unzip
- gperf
- bison
- flex
- make
- patch
- automake
- autoconf
 -gcc-g++
- texinfo (must be at version 4.13-4 since 5+ won't work)
- libusb1.0, libusb1.0-devel

A note on texinfo: due to dependencies, each time you update/modify your cygwin installation (for example: you install an additional package), texinfo will be upgraded to version 5+, while you need version 4+!
Easy solution: as soon as you've installed the additional package, re-run cygwin setup, search texinfo, triple click on "Keep" until you read version 4, then click next.

### Upstream credits

Most patches come from Debian and a few from WinAVR. Thank you guys for the awesome work

### Credits

Consult the [list of contributors](https://github.com/arduino/toolchain-avr/graphs/contributors).

### License

The bash scripts are GPLv2 licensed. Every other software used by these bash scripts has its own license. Consult them to know their terms.

