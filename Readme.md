=== Mac OSX requirements

```bash
sudo port selfupdate
sudo port upgrade outdated
sudo port install wget +universal
sudo port install automake +universal
sudo port install autoconf +universal
sudo port install gpatch +universal
```

=== Debian requirements

```bash
sudo apt-get install build-essential gperf
```

=== Windows requirements

Cygwin installed with all the development tools and gperf

Be aware the texinfo must be at version 4.13-4 since 5+ won't work

