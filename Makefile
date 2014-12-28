.PHONY: all install clean archive distclean doc

all:
	$(MAKE) -C src all
	$(MAKE) -C doc all

doc:
	$(MAKE) -C doc

install:
	$(MAKE) -C src install
	$(MAKE) -C doc install

uninstall:
	$(MAKE) -C src uninstall
	$(MAKE) -C doc uninstall

clean:
	$(MAKE) -C src clean
	$(MAKE) -C doc clean

distclean:
	$(MAKE) -C src distclean
	$(MAKE) -C doc distclean

cleanall: distclean

VERSION=$(shell cat VERSION)

archive:
	$(RM) -r chklref-$(VERSION)
	mkdir -p chklref-$(VERSION)
	$(RM)  chklref-$(VERSION).tar.gz
	git archive master | tar -x -C chklref-$(VERSION)
	(cd chklref-$(VERSION); \
		./configure; \
		make -C doc all;\
		$(RM) -r autom4te.cache config.log config.status)
	tar czf chklref-$(VERSION).tar.gz chklref-$(VERSION)
	$(RM) -r chklref-$(VERSION)

