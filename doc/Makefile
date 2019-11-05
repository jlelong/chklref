.PHONY: all clean cleanall 

all: chklref.1 chklref.pdf clean

chklref.pdf: chklref.tex
	pdflatex chklref.tex
	pdflatex chklref.tex

chklref.1: ../chklref.pl
	help2man --output=$@ ../chklref.pl

clean:
	rm -f chklref.log chklref.aux chklref.out chklref.fls chklref.fdb_latexmk chklref.synctex.gz

cleanall: clean
	rm -f chklref.pdf
