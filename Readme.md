Note: setup has been done on partially set up development machines. If, trying to compile on your machine, you find any package missing from the following list, please open an issue at once! We all can't afford wasting time on setup :)

### Debian requirements

```bash
sudo apt-get install build-essential gperf bison
```

### Mac OSX requirements

```bash
sudo port selfupdate
sudo port upgrade outdated
sudo port install wget +universal
sudo port install automake +universal
sudo port install autoconf +universal
sudo port install gpatch +universal
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

