.PHONY: all clean distclean install uninstall

include ../Make.incl

DOCFILES=chklref.pdf
VERSION_NUMBER=$(shell cat ../VERSION)


all: chklref.pdf clean

install: all
	if ! test -d $(DESTDIR)$(DOCDIR); then $(INSTALL) -d $(DESTDIR)$(DOCDIR); fi
	$(INSTALL) -m 644 $(DOCFILES) $(DESTDIR)$(DOCDIR)


define chk_rm
@for f in $(2); do echo "uninstalling $(1)/$$f"; $(RM) $(1)/$$f; done
endef

uninstall:
	$(call chk_rm, $(DOCDIR), $(DESTDIR)$(DOCFILES))


chklref.pdf: VERSION.tex chklref.tex
	$(PDFLATEX) chklref.tex
	$(PDFLATEX) chklref.tex

VERSION.tex: ../VERSION
	echo "\\def\\\chkVERSION{$(VERSION_NUMBER)}" > VERSION.tex
	

clean:
	$(RM) chklref.dvi chklref.log chklref.aux chklref.out VERSION.log

distclean: clean
	$(RM) chklref.pdf


