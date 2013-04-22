# sample Makefile targets
xepreamble.pdf: xepreamble.tex
	xelatex $<

xebibpreamble.pdf: xebibpreamble.tex sources.bib
	xelatex $<
	biber xebibpreamble
	xelatex $<

# Alternatively, you can hand this task off to latexmk,
# which calculates dependencies and handles xelatex and biber runs:
# xebibpreamble:
# 	latexmk -xelatex xebibpreamble
#
# .PHONY: xebibpreamble

# cleaning

.PHONY: clean clean_pdfs

tex_files := $(wildcard *.tex) 
pdf_files := $(tex_files:tex=pdf)


clean: 
	rm -f *.aux *.log
	# hyperref
	rm -f *.out 
	# biber
	rm -f *.bbl *.bcf *.blg *.run.xml
	# latexmk
	rm -f *.fdb_latexmk *.fls 

# separate PDF cleaning target, since sometimes you want to keep your pdfs
clean_pdfs:
	rm -f $(pdf_files) 

