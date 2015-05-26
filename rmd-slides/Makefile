## Usage ##

# make all:	talk-slides.pdf (slides)
# 		talk-handout.pdf (audience handout)
#		talk-4up.pdf (speaker notes)
#
# make all_key:	talk-slides.key (slides in Keynote)

## Settings ##

latex_msg := quiet	# change to verbose for full LaTeX messaging

# speaker notes formatting: notes output filename will be
# name-$(nup_suffix).pdf
nup_suffix := 4up
nup_layout := 2x2
# for portrait notes, set to --no-landscape
nup_landscape := --landscape

## Knitting ##

talk.md: talk.Rmd
	R -e 'library(knitr); knit("$<")'

## LaTeX for slides ##

talk-slides.tex: talk.md preamble-slides.tex
	pandoc $< \
	    -t beamer \
	    --slide-level 1 \
	    -H preamble-slides.tex \
	    --latex-engine xelatex \
	    --filter overlay_filter \
	    --highlight-style zenburn \
	    -o $@

## LaTeX for speaker notes ##

talk.tex: talk.md preamble-notes.tex
	pandoc $< \
	    -t beamer \
	    -H preamble-notes.tex \
	    -V fontsize=8pt \
	    --filter overlay_filter \
	    --latex-engine xelatex \
	    -o $@

## LaTeX for audience handout with space for notes ##

talk-handout.tex: talk.md preamble-handout.tex
	pandoc $< \
	    -t beamer \
	    --slide-level 1 \
	    -H preamble-handout.tex \
	    --latex-engine xelatex \
	    -V handout \
	    --filter overlay_filter \
	    -o $@

## General PDF rule ##

# NB. talk.pdf is an intermediate file; the final version of the speaker
# notes is generated below
pdfs := talk-slides.pdf talk.pdf talk-handout.pdf

# use latexmk to run xelatex/biber as much as needed
# and quiet error messages (by default)
$(pdfs): %.pdf: %.tex
	latexmk -$(latex_msg) -xelatex $(basename $<)

## Slides in Keynote format ##

slides_key := talk-slides.key

# if you don't have Keynote or don't want to generate the Keynote file
# but want to avoid errors when you use "make all_key", just set the
# slides_key variable to nothing by uncommenting this line:
#
# slides_key :=

$(slides_key): %.key: %.pdf
	rm -f $@
	open -a "PDF To Keynote" $<
	sleep 2
	osascript -e 'tell application "PDF To Keynote"' \
	    -e 'save document 1 in "$(abspath ./$(basename $@))"' \
	    -e 'end tell'

## Notes PDF: two slides and two note pages on a page ##


talk_nup := talk-$(nup_suffix).pdf

$(talk_nup): talk.pdf
	pdfjam $< \
	    $(nup_landscape) \
	    --nup $(nup_layout) \
	    --suffix $(nup_suffix)

all: $(pdfs) $(talk_nup)

all_key: all talk-slides.key

# clean up everything except pdfs, keynote, and knitr cache
clean:
	latexmk -c
	rm -rf *.nav *.snm *.vrb
	rm -rf talk.md
	rm -rf talk*.tex

# clean up everything
reallyclean:
	latexmk -C
	rm -rf cache figure
	rm -rf talk-tikzDictionary
	rm -rf talk.md
	rm -rf talk*.tex
	rm -rf *.nav *.snm *.vrb
	rm -rf talk-slides.key
	rm -rf talk*.pdf
	rm -rf $(talk_nup)

.DEFAULT_GOAL := all

.PHONY: all all_key clean reallyclean

