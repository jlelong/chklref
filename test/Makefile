TESTFILES=test2.tex chklreftest.tex

all: test clean

test:
	for f in ${TESTFILES}; \
	do \
		chklref -q -d $$f; \
	done

clean:
	@echo "Cleaning all..."
	@\rm -f *.aux  *.toc  *.out  *~  *.blg  *.log *.dvi *.tex.chk

distclean: clean
