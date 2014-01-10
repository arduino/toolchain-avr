=== Mac OSX requirements

```bash
sudo port selfupdate
sudo port upgrade outdated
sudo port install gmp +universal
sudo port install mpfr +universal
sudo port install mpc +universal
sudo port install wget +universal
sudo port install automake +universal
sudo port install autoconf +universal
sudo port install gpatch +universal
```

=== Debian requirements

```bash
sudo apt-get install libmpfr-dev libgmp-dev build-essential
```

If you want to cross compile (i.e.: producing 32 bit binaries on 64 bit boxes)
```bash
sudo apt-get install lib32mpfr-dev lib32gmp-dev
```

