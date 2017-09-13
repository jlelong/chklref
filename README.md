# Installation

## System wide installation

You need the root privileges to perform this installation.

Simply run 

```
./configure
make
sudo make install
sudo texhash
```

This last command is required to update the TeX Directory Structure.

This package follows the TDS[1] and installs:
    * the main program in $(prefix)
    * the TeX package chklref.sty in `$(texmf_prefix)/tex/latex/chklref`
    * the manual chklref.pdf in `$(texmf_prefix)/doc/latex/chklref`
    * the Perl parser chkparser in `$(texmf_prefix)/scripts/chklref`

The following default values are used
    * `prefix=/usr/local`
    * `texmf_prefix=$(prefix)/share/texmf`

These default values can be changed with the flags `--prefix`
and `--with-texmf-prefix` passed to the configure script.

**Notes for installation under MacOS X:**

Under MacOS X, your tex distribution is probably not installed under
`/usr/share/texmf` nor `/usr/local/share/texmf`. You are most likely using
the TeXlive distribution provided by MacTeX which installs under
`/usr/local/texlive`. Hence, you should invoke configure with

```
--with-texmf-prefix=/usr/local/texlive/texmf-local
```


## Installation on a single account


This installation does not require any particular privileges.

We assume that the directory `$HOME/bin` is in your `PATH`, if not you have to
add it your `PATH`. You can install the software on your account using

```
./configure --prefix=$HOME --with-texmf-prefix=$HOME/texmf
make
make install
```

**Note:** For the installation on a single account, there is no need to run

    texhash.

**Notes for installation under MacOS X:**

The directory `$HOME/texmf` may not exist because it is replaced by
`$HOME/Library/texmf` instead. So, either use

```
./configure --prefix=$HOME --with-texmf-prefix=$HOME/Library/texmf
```

or create a symbolic link

```
ln -s $HOME/Library/texmf $HOME/texmf
```


# Execution

Just run: `chklref texfile`

To run chklref, you need a Perl interpreter. 

[1] : TeX Directory Structure http://www.tug.org/twg/tds/