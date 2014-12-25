TESTFILES=test2 chklreftest tof

all: test clean

test:
	for f in ${TESTFILES}; \
	do \
		chklref -q "$$f.tex" | tee "${TMPDIR}/$$f.txt"; \
		if test -f "$$f-solution.txt"; then\
			if diff -q "$$f-solution.txt" "${TMPDIR}/$$f.txt"; then\
				echo "-- Check $$f.tex OK";\
			else\
				echo "-- Check $$f.tex FAIL";\
			fi;\
		fi;\
	done

clean:
	@echo "Cleaning all..."
	@\rm -f *.aux  *.toc  *.out  *~  *.blg  *.log *.dvi *.tex.chk

distclean: clean
