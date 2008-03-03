#
# Makefile for the chklref documentation
#
# Jérôme Lelong <jerome.lelong@gmail.com>
# 
# January 2008.
#

LATEX = /sw/bin/latex
DVIPS = /sw/bin/dvips
GS = /sw/bin/gs
datarootdir = /usr/local/share
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
	mkdir -p $(mandir)
	cp manual.pdf $(mandir)/chkltex.pdf

uninstall:
	rm -f $(mandir)/chklref.pdf


clean:
	rm -f manual.dvi manual.log manual.aux manual.out
