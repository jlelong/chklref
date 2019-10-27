.PHONY: all clean cleanall 

all: chklref.pdf clean

chklref.pdf: chklref.tex
	pdflatex chklref.tex
	pdflatex chklref.tex

clean:
	rm -f chklref.log chklref.aux chklref.out chklref.fls chklref.fdb_latexmk chklref.synctex.gz

cleanall: clean
	rm -f chklref.pdf
