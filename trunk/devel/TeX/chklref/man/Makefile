#
# Makefile for the chklref documentation
#
# Jérôme Lelong <jerome.lelong@gmail.com>
# 
# January 2008.
#

LATEX = latex
DVIPS = dvips
GS = gs

manual.dvi: manual.tex
	$(LATEX) $<

manual.ps : manual.dvi
	$(DVIPS) $< -o $@

manual.pdf: manual.dvi
	$(DVIPS) -q -f $< | $(GS) -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$@ -
