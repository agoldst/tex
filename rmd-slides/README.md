# R Markdown to talk slides: a workflow for fussbudgets

Write the lecture in `talk.Rmd`, mixing markdown/LaTeX and R code chunks. `talk.Rmd` contains a model for how to set up for reasonable graphics, code syntax highlighting, and so on.

Generate a PDF of slides with

```Make
make talk-slides.pdf
```

[talk-slides.pdf](talk-slides.pdf) is the result on my system.

If you have Keynote and want to use it as a presentation PDF viewer, install [PDF to Keynote](http://www.cs.hmc.edu/~oneill/freesoftware/pdftokeynote.html) and then do

```Make
make talk-slides.key
```

To generate notes (note pages interleaved with slide pages):

```Make
make talk.pdf
```

I like to print these 4-up in landscape. To generate this format:

```Make
make talk-4up.pdf
```

[talk-4up.pdf](talk-4up.pdf) is the result on my system.

People who hear talks often like a handout with the slides on it for convenient note-taking. To generate a handout:

```Make
make talk-handout.pdf
```

[talk-handout.pdf](talk-handout.pdf) is the result on my system.

To make all slide and note PDFs at once, use `make` all by itself. 

I discuss how the bits and pieces work together in a blog post: ["Programmatic Lecture Slides Made Even More Difficult with R Markdown."](http://andrewgoldstone.com/blog/2015/12/27/rmd-slides) This builds on the [framework for markdown-based lecture slides](../lecture-slides), described in ["Easy Lecture Slides Made Difficult with Pandoc and Beamer."](http://andrewgoldstone.com/blog/2014/12/24/slides/) You can use the Makefile in the latter as a starting point if you want to generalize the model here for a whole series of lectures (e.g. for a course).

## Dependencies

- R packages: knitr, tikzDevice, ggplot2, xtable
- TeX: xelatex and packages: tikz, pgfpages, longtable, booktabs, fancyvrb...oh just install all of TeX Live
- Pandoc
- Make
- the `overlay_filter` Python script in your PATH; it is [elsewhere in this repository](https://github.com/agoldst/tex/blob/master/bin/overlay_filter)
