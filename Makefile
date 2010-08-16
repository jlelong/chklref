.PHONY: all install clean dist distclean

all:
	$(MAKE) -C src all

install:
	$(MAKE) -C src install

uninstall:
	$(MAKE) -C src uninstall

clean:
	$(MAKE) -C src clean

distclean:
	$(MAKE) -C src distclean

VERSION=$(shell cat VERSION)

dist:
	rm -rf chklref-$(VERSION)
	mkdir -p chklref-$(VERSION)
	(cd chklref-$(VERSION); \
	svn export svn+ssh://noe/kora/home/mathfi/lelong/svnroot/devel/chklref; \
	mv chklref/* .; \
	rmdir chklref; )
	tar cf - chklref-$(VERSION) | gzip > chklref-$(VERSION).tar.gz
	rm -rf chklref-$(VERSION)
