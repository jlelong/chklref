#
# Makefile for the chklref documentation
#
# Jérôme Lelong <jerome.lelong@gmail.com>
# 
# January 2008.
#

LATEX = /usr/bin/latex
DVIPS = /usr/bin/dvips
GS = /usr/bin/gs
INSTALL = /usr/bin/install -c
PKGNAME = chklref
TEXMFLOCAL = /usr/local/share/texmf
/usr/local/share/texmf
prefix = /usr/local
installdir = @installdir@
bindir = /usr/local/bin
datarootdir = /usr/local/share
binfiles = chklref
distfiles = configure configure.in chklref.sty chklref.in chkparser README Makefile.in man/manual.tex man/Makefile.in VERSION
sharefiles = chkparser
texfiles = chklref.sty
texmf_prefix = $(TEXMFLOCAL)/tex/latex/$(PKGNAME)
mandir = /usr/local/share/doc

all: manual.pdf

manual.dvi: manual.tex
	$(LATEX) $<
	$(LATEX) $<

manual.ps : manual.dvi
	$(DVIPS) $< -o $@

manual.pdf: manual.dvi
	$(DVIPS) -q -f $< | $(GS) -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$@ -

install:
	mkdir -p $(mandir)/$(PKGNAME)
	$(INSTALL) manual.pdf $(mandir)/$(PKGNAME)/chklref.pdf

uninstall:
	$(RM) $(mandir)/$(PKGNAME)/chklref.pdf
	$(RM) $(mandir)/$(PKGNAME)/README
	rmdir $(mandir)/$(PKGNAME)


clean:
	rm -f manual.dvi manual.log manual.aux manual.out
