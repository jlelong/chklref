TESTFILES=test2 chklreftest tof

all: test clean

test:
	@for f in ${TESTFILES}; \
	do \
		cp ../chklref.sty . ;\
		../chklref.pl -q "$$f.tex" > "${TMPDIR}/$$f.txt"; \
		if test -f "$$f-solution.txt"; then\
			if diff -q "$$f-solution.txt" "${TMPDIR}/$$f.txt"; then\
				echo "-- Checking $$f.tex OK";\
			else\
				diff "$$f-solution.txt" "${TMPDIR}/$$f.txt"; \
				echo "-- Checking $$f.tex FAIL";\
			fi;\
		fi;\
	done

clean:
	@echo "Cleaning all..."
	@\rm -f *.aux  *.toc  *.out  *~  *.blg  *.log *.dvi *.chk

generate:
	@for f in ${TESTFILES}; \
	do \
		cp ../chklref.sty . ;\
		echo "-- Creating $$f-solution.txt"; \
		../chklref.pl -q "$$f.tex" > "$$f-solution.txt"; \
	done
