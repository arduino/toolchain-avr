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
- gperf
- bison
- flex
- subversion
- automake
- autoconf
- texinfo (must be at version 4.13-4 since 5+ won't work)

### Upstream credits

Most patches come from Debian and a few from WinAVR. Thank you guys for the awesome work

### Credits

Consult the [list of contributors](https://github.com/arduino/toolchain-avr/graphs/contributors).

### License

The bash scripts are GPLv2 licensed. Every other software used by these bash scripts has its own license. Consult them to know their terms.

